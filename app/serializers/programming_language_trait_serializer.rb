class ProgrammingLanguageTraitSerializer < ActiveModel::Serializer
  attributes :id, :programming_language_id, :trait_id, :body
  attributes :trait

  def trait
    object.trait
  end
end
