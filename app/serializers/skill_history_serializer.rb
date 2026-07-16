class SkillHistorySerializer < ActiveModel::Serializer
  attributes :id, :body, :skill_id, :created_at, :updated_at
end
