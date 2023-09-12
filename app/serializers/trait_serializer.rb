class TraitSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :programming_language_traits

  def programming_language_traits
    object.programming_language_traits.where.not(body: ["", nil])
  end
end
