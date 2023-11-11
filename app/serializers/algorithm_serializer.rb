class AlgorithmSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :difficulty, :challenge_body, :algorithm_id, :header

  # has_many :language_algorithm_starters, serializer: LanguageAlgorithmStarterSerializer
  attributes :test_cases
  attributes :input_params
  attributes :language_algorithm_starters

  def language_algorithm_starters
    # Check if algorithms should be included based on the request
    if @instance_options[:language_algorithm_starters] == true
      object.language_algorithm_starters.map {|starter| LanguageAlgorithmStarterSerializer.new(starter)}
    end
  end

end
