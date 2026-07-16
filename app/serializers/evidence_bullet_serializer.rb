class EvidenceBulletSerializer < ActiveModel::Serializer
  attributes :id, :body, :position, :occupation_skill_evidence_id, :created_at, :updated_at
end
