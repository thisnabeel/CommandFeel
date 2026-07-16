class OccupationSkillEvidence < ApplicationRecord
  belongs_to :user
  belongs_to :occupation_skill
  belongs_to :cohort, optional: true
  has_many :evidence_bullets, dependent: :destroy

  validates :body, presence: true

  scope :newest_first, -> { order(created_at: :desc) }

  def invalidate_approval!
    update!(approved: false, comment: nil)
  end
end
