class TestCaseSerializer < ActiveModel::Serializer
  attributes :id, :language_algorithm_starter_id, :code, :expectation, :position
end
