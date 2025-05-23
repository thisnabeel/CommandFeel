class QuestStepSerializer < ActiveModel::Serializer
  attributes :id, :image_url, :thumbnail_url, :position, :body, :success_step_id, :failure_step_id, :quest_reward_id, :created_at, :updated_at, :choices

  def choices
    object.quest_step_choices
  end
end 