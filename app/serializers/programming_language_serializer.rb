class ProgrammingLanguageSerializer < ActiveModel::Serializer
  attributes :id, :title, :position, :editor_slug, :algorithms

  def algorithms
    object.language_algorithm_starters.map {|l| LanguageAlgorithmStarterSerializer.new(l)}
  end
end
