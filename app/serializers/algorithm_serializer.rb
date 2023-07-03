class AlgorithmSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :expected, :difficulty
end
