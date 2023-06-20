class QuizSerializer < ActiveModel::Serializer
  attributes :id, :quizable_type, :quizable_id, :jeopardy, :question, :position, :choices
  attributes :skill

  def choices
    object.quiz_choices
  end

  def skill
    object.quizable
  end
end
