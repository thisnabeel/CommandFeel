class ChallengeSerializer < ActiveModel::Serializer
  attributes :id, :challengeable_id, :challengeable_type, :preview, :position, :source_url, :body, :title
end
