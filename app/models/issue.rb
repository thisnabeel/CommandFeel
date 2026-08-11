class Issue < ApplicationRecord
  ISSUE_TYPES = %w[epic story task bug spike feature].freeze
  STATUSES = %w[todo in_progress in_review done].freeze
  PRIORITIES = %w[highest high medium low lowest].freeze

  belongs_to :cohort
  belongs_to :cohort_sprint, optional: true
  belongs_to :parent, class_name: 'Issue', optional: true
  belongs_to :reporter, class_name: 'User'
  belongs_to :assignee, class_name: 'User', optional: true
  has_many :children, class_name: 'Issue', foreign_key: :parent_id, dependent: :nullify,
                      inverse_of: :parent
  has_many :issue_histories, dependent: :destroy

  attr_accessor :history_actor

  validates :title, presence: true, length: { maximum: 500 }
  validates :description, length: { maximum: 50_000 }
  validates :issue_type, inclusion: { in: ISSUE_TYPES }
  validates :status, inclusion: { in: STATUSES }
  validates :priority, inclusion: { in: PRIORITIES }
  validates :number, presence: true, uniqueness: { scope: :cohort_id },
                     numericality: { only_integer: true, greater_than: 0 }
  validates :backlog_rank, presence: true
  validate :sprint_belongs_to_cohort
  validate :parent_rules
  validate :assignee_in_cohort, if: -> { assignee_id.present? }

  before_validation :normalize_fields
  before_validation :assign_number, on: :create
  before_validation :assign_backlog_rank, on: :create
  after_create :record_created_history
  after_update :record_updated_history

  scope :ordered_backlog, -> { order(:backlog_rank, :number) }
  scope :in_backlog, -> { where(cohort_sprint_id: nil) }
  scope :in_sprint, ->(sprint_id) { where(cohort_sprint_id: sprint_id) }

  def key
    prefix = cohort&.issue_key_prefix.presence || 'PROJ'
    "#{prefix}-#{number}"
  end

  def epic?
    issue_type == 'epic'
  end

  private

  def record_created_history
    actor = history_actor || reporter
    IssueHistory.record_created!(self, actor)
  rescue StandardError => e
    Rails.logger.error("IssueHistory create failed for issue #{id}: #{e.message}")
  end

  def record_updated_history
    actor = history_actor
    return unless actor

    changed = previous_changes.slice(*IssueHistory::TRACKED_FIELDS)
    return if changed.blank?

    entries = changed.map do |field, (before, after)|
      {
        'field' => field,
        'field_label' => IssueHistory::FIELD_LABELS[field] || field.humanize,
        'from' => IssueHistory.serialize_value(before),
        'to' => IssueHistory.serialize_value(after),
        'from_display' => IssueHistory.display_value(field, before, cohort_id),
        'to_display' => IssueHistory.display_value(field, after, cohort_id)
      }
    end

    IssueHistory.create!(
      issue: self,
      user: actor,
      event: 'updated',
      change_set: entries
    )
  rescue StandardError => e
    Rails.logger.error("IssueHistory update failed for issue #{id}: #{e.message}")
  end

  def normalize_fields
    self.title = title.to_s.strip
    self.description = '' if description.nil?
    self.issue_type = issue_type.to_s.downcase.presence || 'task'
    self.status = status.to_s.downcase.presence || 'todo'
    self.priority = priority.to_s.downcase.presence || 'medium'
    self.parent_id = nil if epic?
  end

  def assign_number
    return if number.present? || cohort.blank?

    cohort.with_lock do
      max = cohort.issues.maximum(:number) || 0
      self.number = max + 1
    end
  end

  def assign_backlog_rank
    return if backlog_rank.present? && !backlog_rank.to_d.zero?
    return if cohort_id.blank?

    max = cohort.issues.maximum(:backlog_rank)
    self.backlog_rank = max.nil? ? BigDecimal('1000') : (max.to_d + 1000)
  end

  def sprint_belongs_to_cohort
    return if cohort_sprint_id.blank?
    return unless cohort_sprint
    return if cohort_sprint.cohort_id == cohort_id

    errors.add(:cohort_sprint_id, 'must belong to the same cohort')
  end

  def parent_rules
    return if parent_id.blank?

    if epic?
      errors.add(:parent_id, 'epics cannot have a parent')
      return
    end

    return unless parent

    unless parent.cohort_id == cohort_id
      errors.add(:parent_id, 'must belong to the same cohort')
      return
    end

    unless parent.epic?
      errors.add(:parent_id, 'must be an epic')
      return
    end

    errors.add(:parent_id, 'cannot be itself') if parent_id == id
  end

  def assignee_in_cohort
    return unless cohort_id && assignee_id

    enrolled = CohortUser
               .where(cohort_id: cohort_id, user_id: assignee_id, status: %w[applied assigned])
               .exists?
    return if enrolled || User.is_admin?(assignee)

    errors.add(:assignee_id, 'must be a member of this cohort')
  end
end
