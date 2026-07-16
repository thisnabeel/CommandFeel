class OccupationSkillUserNote < ApplicationRecord
  belongs_to :user
  belongs_to :occupation_skill

  validates :user_id, uniqueness: { scope: :occupation_skill_id }
end
