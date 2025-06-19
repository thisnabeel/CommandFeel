class ResumePointSerializer < ActiveModel::Serializer
  attributes :id, :body, :position, :challenge_id, :created_at, :updated_at
end 