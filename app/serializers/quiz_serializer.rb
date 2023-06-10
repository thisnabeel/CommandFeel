class QuizSerializer < ActiveModel::Serializer
  attributes :id, :quizable_type, :quizable_id, :jeopardy, :question, :position
end
