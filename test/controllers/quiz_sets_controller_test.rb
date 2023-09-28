require "test_helper"

class QuizSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quiz_set = quiz_sets(:one)
  end

  test "should get index" do
    get quiz_sets_url, as: :json
    assert_response :success
  end

  test "should create quiz_set" do
    assert_difference("QuizSet.count") do
      post quiz_sets_url, params: { quiz_set: { description: @quiz_set.description, pop_quizable: @quiz_set.pop_quizable, position: @quiz_set.position, quiz_setable_id: @quiz_set.quiz_setable_id, quiz_setable_type: @quiz_set.quiz_setable_type, title: @quiz_set.title } }, as: :json
    end

    assert_response :created
  end

  test "should show quiz_set" do
    get quiz_set_url(@quiz_set), as: :json
    assert_response :success
  end

  test "should update quiz_set" do
    patch quiz_set_url(@quiz_set), params: { quiz_set: { description: @quiz_set.description, pop_quizable: @quiz_set.pop_quizable, position: @quiz_set.position, quiz_setable_id: @quiz_set.quiz_setable_id, quiz_setable_type: @quiz_set.quiz_setable_type, title: @quiz_set.title } }, as: :json
    assert_response :success
  end

  test "should destroy quiz_set" do
    assert_difference("QuizSet.count", -1) do
      delete quiz_set_url(@quiz_set), as: :json
    end

    assert_response :no_content
  end
end
