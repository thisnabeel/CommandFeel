class Occupation < ApplicationRecord
  has_many :cohort_users
  has_many :occupation_skills, dependent: :destroy
  has_many :skills, through: :occupation_skills

  before_destroy :ensure_no_cohort_users

  private

  def ensure_no_cohort_users
    return unless cohort_users.exists?

    errors.add(:base, 'Cannot delete occupation with enrolled cohort users')
    throw(:abort)
  end
end
