class ProofLinkSerializer < ActiveModel::Serializer
  attributes :id, :proof_id, :url, :title, :description, :user_id
end
