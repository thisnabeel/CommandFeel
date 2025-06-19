class QuestStepChoice < ApplicationRecord
  belongs_to :quest_step
  belongs_to :next_step, class_name: 'QuestStep', optional: true

  validates :body, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
end 