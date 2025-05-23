class QuestSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :position, :image_url, :difficulty, :created_at, :updated_at, :steps, :skill

  def steps
    object.quest_steps.order(:position)
  end

  def skill
    object.skill
  end
end 