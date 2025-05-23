class LeetcodeProblemSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :difficulty, :url, :topics
end
