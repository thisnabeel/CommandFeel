class AlgorithmSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :difficulty

  has_many :language_algorithm_starters, serializer: LanguageAlgorithmStarterSerializer
  attributes :test_cases
  attributes :input_params



end
