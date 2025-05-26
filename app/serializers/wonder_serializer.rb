class WonderSerializer < ActiveModel::Serializer
  attributes :id, :title, :image, :description, :difficulty, :position, 
             :visibility, :code, :slug, :is_course, :created_at, :updated_at

  has_many :wonders
  has_many :quests
  has_many :abstractions
  has_many :challenges
  has_many :quizzes
  has_many :quiz_sets
end 