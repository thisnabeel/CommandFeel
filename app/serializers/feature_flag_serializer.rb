class FeatureFlagSerializer < ActiveModel::Serializer
  attributes :id, :key, :enabled, :description, :created_at, :updated_at
end
