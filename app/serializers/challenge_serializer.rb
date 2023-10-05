class ChallengeSerializer < ActiveModel::Serializer
  attributes :id, :challengeable_id, :challengeable_type, :preview, :position, :source_url, :body, :title, :challengeable

  def challengeable
    if object.challengeable_type === "Skill"
      object.challengeable
    end
  end
end
