class ProofSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :challenge_id, :title, :description, :challenge
  has_many :proof_links
  # has_one :challenge
  def challenge
    ChallengeSerializer.new(object.challenge)
  end
end
