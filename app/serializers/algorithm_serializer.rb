class AlgorithmSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :difficulty

  attributes :language_algorithm_starters
  attributes :test_cases
  attributes :input_params


  def language_algorithm_starters
    object.language_algorithm_starters.map {|obj| LanguageAlgorithmStarterSerializer.new(obj)}
  end

end
