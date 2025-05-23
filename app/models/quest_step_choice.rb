class QuestStepChoice < ApplicationRecord
  belongs_to :quest_step

  validates :body, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
end 