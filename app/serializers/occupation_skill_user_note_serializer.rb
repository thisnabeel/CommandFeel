class OccupationSkillUserNoteSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :occupation_skill_id, :updated_at
end
