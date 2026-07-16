class CohortSprintSerializer < ActiveModel::Serializer
  attributes :id, :cohort_id, :position, :goal, :active, :created_at, :updated_at
end
