class ChallengeSerializer < ActiveModel::Serializer
  attributes :id, :challengeable_id, :challengeable_type, :preview, :position, :source_url, :body, :title, :challengeable, :resume_points

  def challengeable
    if object.challengeable_type === "Skill"
      object.challengeable
    end
  end

  def resume_points
    object.resume_points.map {|rp| ResumePointSerializer.new(rp)}
  end
end
