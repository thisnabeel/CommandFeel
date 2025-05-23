require "test_helper"

class ComprehensionQuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comprehension_question = comprehension_questions(:one)
  end

  test "should get index" do
    get comprehension_questions_url, as: :json
    assert_response :success
  end

  test "should create comprehension_question" do
    assert_difference("ComprehensionQuestion.count") do
      post comprehension_questions_url, params: { comprehension_question: { answer: @comprehension_question.answer, leetcode_problem_id: @comprehension_question.leetcode_problem_id, question: @comprehension_question.question, question_type: @comprehension_question.question_type } }, as: :json
    end

    assert_response :created
  end

  test "should show comprehension_question" do
    get comprehension_question_url(@comprehension_question), as: :json
    assert_response :success
  end

  test "should update comprehension_question" do
    patch comprehension_question_url(@comprehension_question), params: { comprehension_question: { answer: @comprehension_question.answer, leetcode_problem_id: @comprehension_question.leetcode_problem_id, question: @comprehension_question.question, question_type: @comprehension_question.question_type } }, as: :json
    assert_response :success
  end

  test "should destroy comprehension_question" do
    assert_difference("ComprehensionQuestion.count", -1) do
      delete comprehension_question_url(@comprehension_question), as: :json
    end

    assert_response :no_content
  end
end
