class PhraseListSerializer < ActiveModel::Serializer
  attributes :id, :body, :role, :created_at, :links_count

  def links_count
    object.phrase_links.count
  end
end 