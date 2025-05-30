class Quest < ApplicationRecord
  belongs_to :questable, polymorphic: true
  has_many :quest_steps, dependent: :destroy

  validates :title, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
  validates :difficulty, presence: true, numericality: { only_integer: true }

  def self.popular(limit = 10)
    quests = Quest.includes(quest_steps: :quest_step_choices)
                 .where.not(quest_steps: { image_url: [nil, ''] })
                 .distinct
                 .to_a
    quests.sort_by { |quest| quest.quest_steps.size }.reverse.first(limit)
  end
end 