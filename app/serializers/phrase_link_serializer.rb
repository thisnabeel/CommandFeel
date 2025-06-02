class PhraseLinkSerializer < ActiveModel::Serializer
  attributes :id, :title, :explanation, :category, :phrasable_type, :phrasable_id
  belongs_to :phrase
end 