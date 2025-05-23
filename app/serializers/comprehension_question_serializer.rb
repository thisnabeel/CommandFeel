class ComprehensionQuestionSerializer < ActiveModel::Serializer
  attributes :id, :question, :answer, :question_type
  has_one :leetcode_problem
end
