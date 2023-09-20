class UserQuizStatusSerializer < ActiveModel::Serializer
  attributes :id, :status
  has_one :user
  has_one :quiz
end
