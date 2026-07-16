class CohortSprint < ApplicationRecord
  belongs_to :cohort

  validates :position, presence: true,
                       uniqueness: { scope: :cohort_id },
                       numericality: { only_integer: true, greater_than: 0 }
  validates :goal, length: { maximum: 10_000 }
  validate :cohort_must_have_one_active

  before_validation :normalize_goal
  after_save :ensure_single_active, if: :saved_change_to_active?
  after_destroy :activate_fallback_if_needed

  scope :ordered, -> { order(:position) }
  scope :active_sprints, -> { where(active: true) }

  def activate!
    transaction do
      cohort.cohort_sprints.where.not(id: id).update_all(active: false)
      update!(active: true)
    end
  end

  private

  def normalize_goal
    self.goal = '' if goal.nil?
  end

  def ensure_single_active
    return unless active?

    cohort.cohort_sprints.where.not(id: id).where(active: true).update_all(active: false)
  end

  def activate_fallback_if_needed
    return if cohort.cohort_sprints.active_sprints.exists?

    fallback = cohort.cohort_sprints.ordered.first
    fallback&.update_columns(active: true)
  end

  def cohort_must_have_one_active
    return unless cohort
    return if active?
    return if new_record? && !cohort.cohort_sprints.exists?

    others_active = cohort.cohort_sprints.where(active: true).where.not(id: id).exists?
    return if others_active

    # Deactivating the only active sprint is not allowed unless another will be activated
    if !active? && active_changed? && active_was == true
      errors.add(:active, 'at least one sprint must remain active')
    end
  end
end
