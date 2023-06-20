class QuizChoiceSerializer < ActiveModel::Serializer
  attributes :id, :position, :correct, :body
  has_one :quiz
end
