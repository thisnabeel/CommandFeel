class SavedJobSerializer < ActiveModel::Serializer
  attributes :id, :title, :company, :position, :jd_link, :jd, :stage, :skills, :user_id
end
