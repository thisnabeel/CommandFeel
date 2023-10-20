class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :description, :position
  attributes :proof
  attributes :skills

  def proof
    if object.proof.present?
      ProofSerializer.new(object.proof)
    else
      nil
    end
  end

  def skills
    object.project_skills.map {|skill| ProjectSkillSerializer.new(skill)}
  end
end
