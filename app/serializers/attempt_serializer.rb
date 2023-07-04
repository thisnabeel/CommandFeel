class AttemptSerializer < ActiveModel::Serializer
  attributes :id, :algorithm_id, :programming_language_id, :user_id, :error_message, :passing
end
