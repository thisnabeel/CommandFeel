class CohortUserJobSerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :description, :position, :archive, :cohort_user_id,
             :created_at, :updated_at
end
