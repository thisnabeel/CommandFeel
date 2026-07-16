class CohortUser < ApplicationRecord
  STATUSES = %w[open applied assigned].freeze

  belongs_to :cohort
  belongs_to :user, optional: true
  belongs_to :occupation
  has_many :questions, as: :questionable, dependent: :destroy

  validates :status, inclusion: { in: STATUSES }
  validate :user_presence_matches_status
  validate :one_seat_per_user_per_cohort

  before_validation :normalize_open_slot

  def open?
    status == 'open'
  end

  def applied?
    status == 'applied'
  end

  def assigned?
    status == 'assigned'
  end

  def clear_seat!
    update!(user_id: nil, status: 'open')
  end

  def accept!
    unless applied?
      errors.add(:base, 'Slot is not in applied status')
      raise ActiveRecord::RecordInvalid, self
    end

    update!(status: 'assigned')
  end

  def assign_user!(assignee)
    update!(user: assignee, status: 'assigned')
  end

  def apply!(applicant)
    unless open?
      errors.add(:base, 'Slot is not open')
      raise ActiveRecord::RecordInvalid, self
    end

    update!(user: applicant, status: 'applied')
  end

  private

  def normalize_open_slot
    return unless status == 'open'

    self.user_id = nil
  end

  def user_presence_matches_status
    case status
    when 'open'
      errors.add(:user_id, 'must be blank for open slots') if user_id.present?
    when 'applied', 'assigned'
      errors.add(:user_id, 'must be present when status is applied or assigned') if user_id.blank?
    end
  end

  def one_seat_per_user_per_cohort
    return if user_id.blank?

    conflict = CohortUser
               .where(cohort_id: cohort_id, user_id: user_id)
               .where.not(id: id)
               .exists?

    return unless conflict

    errors.add(:user_id, 'already has a seat in this cohort')
  end
end
