class ProjectSkillSerializer < ActiveModel::Serializer
  attributes :id, :skill_id, :project_id, :position, :description, :user_id
  attributes :title

  def title
    object.skill.title
  end

end
