class SkillSerializer < ActiveModel::Serializer
  attributes :id, :title, :skill_id, :image, :description, :difficulty, :position, :visibility, :code, :slug, :is_course


  attributes :abstractions
  attributes :challenges
  attributes :quizzes

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


  def quizzes
    if options && options[:quizzes] === true
      return object.quizzes
    else
      return []
    end
  end

  def skills
    ActiveModel::Serializer::CollectionSerializer.new(@object.skills, serializer: SkillSerializer)
  end
end
