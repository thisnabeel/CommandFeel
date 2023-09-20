require "test_helper"

class UserQuizStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_quiz_status = user_quiz_statuses(:one)
  end

  test "should get index" do
    get user_quiz_statuses_url, as: :json
    assert_response :success
  end

  test "should create user_quiz_status" do
    assert_difference("UserQuizStatus.count") do
      post user_quiz_statuses_url, params: { user_quiz_status: { quiz_id: @user_quiz_status.quiz_id, status: @user_quiz_status.status, user_id: @user_quiz_status.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show user_quiz_status" do
    get user_quiz_status_url(@user_quiz_status), as: :json
    assert_response :success
  end

  test "should update user_quiz_status" do
    patch user_quiz_status_url(@user_quiz_status), params: { user_quiz_status: { quiz_id: @user_quiz_status.quiz_id, status: @user_quiz_status.status, user_id: @user_quiz_status.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy user_quiz_status" do
    assert_difference("UserQuizStatus.count", -1) do
      delete user_quiz_status_url(@user_quiz_status), as: :json
    end

    assert_response :no_content
  end
end
