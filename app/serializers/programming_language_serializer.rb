class ProgrammingLanguageSerializer < ActiveModel::Serializer
  attributes :id, :title, :position, :editor_slug, :algorithms
  attribute :algorithms, if: :include_algorithms?

  def include_algorithms?
    # Check if algorithms should be included based on the request
    @instance_options[:algorithms]
  end

  def algorithms
    object.language_algorithm_starters.map {|l| LanguageAlgorithmStarterSerializer.new(l)}
  end
end
