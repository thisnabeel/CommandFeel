class QuizSetSerializer < ActiveModel::Serializer
  attributes :id, :quiz_setable_id, :quiz_setable_type, :position, :title, :description, :pop_quizable, :quizzes

  def quizzes
      return ActiveModel::Serializer::CollectionSerializer.new(@object.quizzes, serializer: QuizSerializer)
  end
end
