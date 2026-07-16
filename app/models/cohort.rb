class Cohort < ApplicationRecord
  has_many :cohort_users, dependent: :destroy
  has_many :users, through: :cohort_users
  has_many :cohort_sprints, -> { order(:position) }, dependent: :destroy, inverse_of: :cohort
  has_many :occupation_skill_evidences, dependent: :nullify

  accepts_nested_attributes_for :cohort_sprints, allow_destroy: true

  after_create :seed_default_sprints, if: :seed_sprint_count?

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

  def seed_sprint_count?
    seed_sprints_count.present? || cohort_sprints.empty?
  end

  def seed_default_sprints
    return if cohort_sprints.exists?

    count = seed_sprints_count.presence || 6
    build_sprints!(count)
  end
end
