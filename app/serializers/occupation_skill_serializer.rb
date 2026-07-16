class OccupationSkillSerializer < ActiveModel::Serializer
  attributes :id, :occupation_id, :skill_id, :occupation_skill_id, :position,
             :title, :description, :video_url, :created_at, :updated_at,
             :skill_title, :display_title

  def skill_title
    object.skill&.title
  end

  def display_title
    object.display_title
  end
end
