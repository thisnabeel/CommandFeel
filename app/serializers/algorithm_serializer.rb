class AlgorithmSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :expected, :difficulty
  attributes :expected_with_type
  attributes :language_algorithm_starters

  def expected_with_type
    return object.expected_with_type
  end

  def language_algorithm_starters
    object.language_algorithm_starters.map {|obj| LanguageAlgorithmStarterSerializer.new(obj)}
  end
end
