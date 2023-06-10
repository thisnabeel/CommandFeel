class AbstractionSerializer < ActiveModel::Serializer
  attributes :id, :abstractable_id, :abstractable_type, :article, :last_edited_by, :preview, :position, :source_url, :body
end
