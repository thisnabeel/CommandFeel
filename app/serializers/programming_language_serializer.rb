class ProgrammingLanguageSerializer < ActiveModel::Serializer
  attributes :id, :title, :position, :editor_slug
  attribute :algorithms, if: :include_algorithms?
  attribute :challenges, if: :include_challenges?

  def include_algorithms?
    # Check if algorithms should be included based on the request
    @instance_options[:algorithms]
  end

  def include_challenges?
    # Check if challenges should be included based on the request
    @instance_options[:challenges]
  end

  def challenges
    object.challenges.map {|l| ChallengeSerializer.new(l)}
  end

  def algorithms
    object.language_algorithm_starters.map {|l| LanguageAlgorithmStarterSerializer.new(l)}
  end
end
