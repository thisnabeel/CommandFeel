class SkillSerializer < ActiveModel::Serializer
  attributes :id, :title, :skill_id, :image, :description, :difficulty, :position, :visibility, :code, :slug, :is_course


  attributes :abstractions
  attributes :challenges
  # attributes :quizzes
  attributes :quiz_sets


  def options
    instance_options[:serializer_options]
  end

  def abstractions
    if options && options[:abstractions] === true
      return object.abstractions
    else
      return []
    end
  end


  def challenges
    if options && options[:challenges] === true
      return object.challenges
    else
      return []
    end
  end


  # def quizzes
  #   if options && options[:quizzes] === true
  #     return ActiveModel::Serializer::CollectionSerializer.new(@object.quizzes, serializer: QuizSerializer)

  #   else
  #     return []
  #   end
  # end


  def quiz_sets
    if options && options[:quizzes] === true
      return ActiveModel::Serializer::CollectionSerializer.new(@object.quiz_sets, serializer: QuizSetSerializer)
    else
      return []
    end
  end

  def skills
    ActiveModel::Serializer::CollectionSerializer.new(@object.skills, serializer: SkillSerializer)
  end
end
