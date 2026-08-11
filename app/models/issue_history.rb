class IssueHistory < ApplicationRecord
  TRACKED_FIELDS = %w[
    title description issue_type status priority
    assignee_id cohort_sprint_id parent_id
  ].freeze

  FIELD_LABELS = {
    'title' => 'Summary',
    'description' => 'Description',
    'issue_type' => 'Issue Type',
    'status' => 'Status',
    'priority' => 'Priority',
    'assignee_id' => 'Assignee',
    'cohort_sprint_id' => 'Sprint',
    'parent_id' => 'Epic'
  }.freeze

  STATUS_LABELS = {
    'todo' => 'To Do',
    'in_progress' => 'In Progress',
    'in_review' => 'In Review',
    'done' => 'Done'
  }.freeze

  TYPE_LABELS = {
    'epic' => 'Epic',
    'story' => 'Story',
    'task' => 'Task',
    'bug' => 'Bug',
    'spike' => 'Spike',
    'feature' => 'Feature'
  }.freeze

  PRIORITY_LABELS = {
    'highest' => 'Highest',
    'high' => 'High',
    'medium' => 'Medium',
    'low' => 'Low',
    'lowest' => 'Lowest'
  }.freeze

  belongs_to :issue
  belongs_to :user

  validates :event, inclusion: { in: %w[created updated] }
  validates :change_set, presence: true, unless: -> { event == 'created' }

  scope :newest_first, -> { order(created_at: :desc, id: :desc) }

  def self.record_created!(issue, actor)
    return unless issue && actor

    create!(
      issue: issue,
      user: actor,
      event: 'created',
      change_set: []
    )
  end

  def self.record_update!(issue, actor, previous_attrs)
    return unless issue && actor
    return if previous_attrs.blank?

    entries = build_change_entries(issue, previous_attrs)
    return if entries.empty?

    create!(
      issue: issue,
      user: actor,
      event: 'updated',
      change_set: entries
    )
  end

  def self.build_change_entries(issue, previous_attrs)
    TRACKED_FIELDS.filter_map do |field|
      before = previous_attrs[field]
      after = issue.public_send(field)
      next if values_equal?(before, after)

      {
        'field' => field,
        'field_label' => FIELD_LABELS[field] || field.humanize,
        'from' => serialize_value(before),
        'to' => serialize_value(after),
        'from_display' => display_value(field, before, issue.cohort_id),
        'to_display' => display_value(field, after, issue.cohort_id)
      }
    end
  end

  def self.values_equal?(a, b)
    serialize_value(a) == serialize_value(b)
  end

  def self.serialize_value(value)
    return nil if value.nil?
    return value.to_s if value.is_a?(Numeric)

    value
  end

  def self.display_value(field, value, cohort_id = nil)
    return 'None' if value.nil? || value == ''

    case field
    when 'status'
      STATUS_LABELS[value.to_s] || value.to_s.humanize
    when 'issue_type'
      TYPE_LABELS[value.to_s] || value.to_s.humanize
    when 'priority'
      PRIORITY_LABELS[value.to_s] || value.to_s.humanize
    when 'assignee_id'
      user = User.find_by(id: value)
      user_label(user) || "User ##{value}"
    when 'cohort_sprint_id'
      sprint = CohortSprint.find_by(id: value)
      sprint ? "Sprint #{sprint.position}" : "Sprint ##{value}"
    when 'parent_id'
      parent = Issue.find_by(id: value)
      parent ? "#{parent.key} — #{parent.title}" : "Issue ##{value}"
    when 'description'
      text = value.to_s
      text.length > 80 ? "#{text[0, 80]}…" : text.presence || 'None'
    else
      value.to_s.presence || 'None'
    end
  end

  def self.user_label(user)
    return nil unless user

    name = [user.first_name, user.last_name].map { |p| p.to_s.strip }.reject(&:blank?).join(' ')
    return name if name.present?
    return user.username if user.username.present?

    user.email.to_s.split('@').first.presence || user.email
  end
  private_class_method :user_label, :values_equal?
end
