class ProofSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :challenge_id, :title, :description
  has_many :proof_links
  

end
