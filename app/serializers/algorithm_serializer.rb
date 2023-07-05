class AlgorithmSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :expected, :difficulty
  attributes :expected_with_type

  def expected_with_type
    return object.expected_with_type
  end
end
