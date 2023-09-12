require "test_helper"

class LanguageAlgorithmStartersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @language_algorithm_starter = language_algorithm_starters(:one)
  end

  test "should get index" do
    get language_algorithm_starters_url, as: :json
    assert_response :success
  end

  test "should create language_algorithm_starter" do
    assert_difference("LanguageAlgorithmStarter.count") do
      post language_algorithm_starters_url, params: { language_algorithm_starter: { algorithm_id: @language_algorithm_starter.algorithm_id, code: @language_algorithm_starter.code, code_lines: @language_algorithm_starter.code_lines, language_id: @language_algorithm_starter.language_id, video_url: @language_algorithm_starter.video_url } }, as: :json
    end

    assert_response :created
  end

  test "should show language_algorithm_starter" do
    get language_algorithm_starter_url(@language_algorithm_starter), as: :json
    assert_response :success
  end

  test "should update language_algorithm_starter" do
    patch language_algorithm_starter_url(@language_algorithm_starter), params: { language_algorithm_starter: { algorithm_id: @language_algorithm_starter.algorithm_id, code: @language_algorithm_starter.code, code_lines: @language_algorithm_starter.code_lines, language_id: @language_algorithm_starter.language_id, video_url: @language_algorithm_starter.video_url } }, as: :json
    assert_response :success
  end

  test "should destroy language_algorithm_starter" do
    assert_difference("LanguageAlgorithmStarter.count", -1) do
      delete language_algorithm_starter_url(@language_algorithm_starter), as: :json
    end

    assert_response :no_content
  end
end
