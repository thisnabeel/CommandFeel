require "test_helper"

class AttemptsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @attempt = attempts(:one)
  end

  test "should get index" do
    get attempts_url, as: :json
    assert_response :success
  end

  test "should create attempt" do
    assert_difference("Attempt.count") do
      post attempts_url, params: { attempt: { algorithm_id: @attempt.algorithm_id, error_message: @attempt.error_message, passing: @attempt.passing, programming_language_id: @attempt.programming_language_id, user_id: @attempt.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show attempt" do
    get attempt_url(@attempt), as: :json
    assert_response :success
  end

  test "should update attempt" do
    patch attempt_url(@attempt), params: { attempt: { algorithm_id: @attempt.algorithm_id, error_message: @attempt.error_message, passing: @attempt.passing, programming_language_id: @attempt.programming_language_id, user_id: @attempt.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy attempt" do
    assert_difference("Attempt.count", -1) do
      delete attempt_url(@attempt), as: :json
    end

    assert_response :no_content
  end
end
