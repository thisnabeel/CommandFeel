class QuestStepChoiceSerializer < ActiveModel::Serializer
  attributes :id, :body, :status, :position, :reasoning, :created_at, :updated_at, :next_step_id
end 