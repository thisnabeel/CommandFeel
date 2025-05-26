class QuestSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :position, :image_url, :difficulty, :created_at, :updated_at, :steps, :questable

  def steps
    object.quest_steps.order(:position)
  end

  def questable
    object.questable
  end
end 