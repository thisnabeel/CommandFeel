class Chapter < ApplicationRecord
  belongs_to :chapter, optional: true
  has_many :chapters

  has_many :abstractions, as: :abstractable, dependent: :destroy
  has_many :challenges, as: :challengeable, dependent: :destroy

  has_many :quizzes, as: :quizable
  has_many :quiz_sets, as: :quiz_setable, dependent: :destroy
  
  has_many :quests, dependent: :destroy
end
