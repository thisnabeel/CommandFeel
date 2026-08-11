class Cohort < ApplicationRecord
  has_many :cohort_users, dependent: :destroy
  has_many :users, through: :cohort_users
  has_many :cohort_sprints, -> { order(:position) }, dependent: :destroy, inverse_of: :cohort
  has_many :occupation_skill_evidences, dependent: :nullify
  has_many :issues, dependent: :destroy

  accepts_nested_attributes_for :cohort_sprints, allow_destroy: true

  validates :issue_key_prefix, presence: true, length: { maximum: 10 },
                               format: { with: /\A[A-Z][A-Z0-9]*\z/, message: 'must be uppercase letters/numbers' }

  before_validation :normalize_issue_key_prefix
  after_create :seed_default_sprints, if: :seed_sprint_count?

  def self.prefix_from_title(title)
    cleaned = title.to_s.gsub(/[^A-Za-z0-9]/, '')
    prefix = cleaned.upcase[0, 4]
    prefix.present? ? prefix : 'PROJ'
  end


  attr_accessor :seed_sprints_count

  def sprints_count
    if association(:cohort_sprints).loaded?
      cohort_sprints.size
    else
      cohort_sprints.count
    end
  end

  def active_sprint
    cohort_sprints.find_by(active: true) || cohort_sprints.first
  end

  def build_sprints!(count)
    count = [count.to_i, 1].max
    transaction do
      count.times do |i|
        cohort_sprints.create!(position: i + 1, goal: '', active: i.zero?)
      end
    end
  end

  private

  def normalize_issue_key_prefix
    if issue_key_prefix.blank?
      self.issue_key_prefix = self.class.prefix_from_title(title)
    else
      self.issue_key_prefix = issue_key_prefix.to_s.upcase.gsub(/[^A-Z0-9]/, '')[0, 10]
      self.issue_key_prefix = 'PROJ' if issue_key_prefix.blank?
    end
  end

  def seed_sprint_count?
    seed_sprints_count.present? || cohort_sprints.empty?
  end

  def seed_default_sprints
    return if cohort_sprints.exists?

    count = seed_sprints_count.presence || 6
    build_sprints!(count)
  end
end
