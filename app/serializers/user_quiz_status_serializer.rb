class UserQuizStatusSerializer < ActiveModel::Serializer
  attributes :id, :status, :quiz, :quiz_id

  def quiz
    QuizSerializer.new(object.quiz)
  end

end
