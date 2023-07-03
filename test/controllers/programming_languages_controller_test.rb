require "test_helper"

class ProgrammingLanguagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @programming_language = programming_languages(:one)
  end

  test "should get index" do
    get programming_languages_url, as: :json
    assert_response :success
  end

  test "should create programming_language" do
    assert_difference("ProgrammingLanguage.count") do
      post programming_languages_url, params: { programming_language: { editor_slug: @programming_language.editor_slug, position: @programming_language.position, title: @programming_language.title } }, as: :json
    end

    assert_response :created
  end

  test "should show programming_language" do
    get programming_language_url(@programming_language), as: :json
    assert_response :success
  end

  test "should update programming_language" do
    patch programming_language_url(@programming_language), params: { programming_language: { editor_slug: @programming_language.editor_slug, position: @programming_language.position, title: @programming_language.title } }, as: :json
    assert_response :success
  end

  test "should destroy programming_language" do
    assert_difference("ProgrammingLanguage.count", -1) do
      delete programming_language_url(@programming_language), as: :json
    end

    assert_response :no_content
  end
end
