class PhraseSerializer < ActiveModel::Serializer
  attributes :id, :body, :role, :created_at, :updated_at
  
  has_many :phrase_links
  
  def phrase_links
    object.phrase_links.order(created_at: :desc)
  end
end 