require "test_helper"

class QuizChoicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quiz_choice = quiz_choices(:one)
  end

  test "should get index" do
    get quiz_choices_url, as: :json
    assert_response :success
  end

  test "should create quiz_choice" do
    assert_difference("QuizChoice.count") do
      post quiz_choices_url, params: { quiz_choice: { body: @quiz_choice.body, correct: @quiz_choice.correct, position: @quiz_choice.position, quiz_id: @quiz_choice.quiz_id } }, as: :json
    end

    assert_response :created
  end

  test "should show quiz_choice" do
    get quiz_choice_url(@quiz_choice), as: :json
    assert_response :success
  end

  test "should update quiz_choice" do
    patch quiz_choice_url(@quiz_choice), params: { quiz_choice: { body: @quiz_choice.body, correct: @quiz_choice.correct, position: @quiz_choice.position, quiz_id: @quiz_choice.quiz_id } }, as: :json
    assert_response :success
  end

  test "should destroy quiz_choice" do
    assert_difference("QuizChoice.count", -1) do
      delete quiz_choice_url(@quiz_choice), as: :json
    end

    assert_response :no_content
  end
end
