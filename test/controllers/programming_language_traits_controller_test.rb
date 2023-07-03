require "test_helper"

class ProgrammingLanguageTraitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @programming_language_trait = programming_language_traits(:one)
  end

  test "should get index" do
    get programming_language_traits_url, as: :json
    assert_response :success
  end

  test "should create programming_language_trait" do
    assert_difference("ProgrammingLanguageTrait.count") do
      post programming_language_traits_url, params: { programming_language_trait: { body: @programming_language_trait.body, programming_language_id: @programming_language_trait.programming_language_id, trait_id: @programming_language_trait.trait_id } }, as: :json
    end

    assert_response :created
  end

  test "should show programming_language_trait" do
    get programming_language_trait_url(@programming_language_trait), as: :json
    assert_response :success
  end

  test "should update programming_language_trait" do
    patch programming_language_trait_url(@programming_language_trait), params: { programming_language_trait: { body: @programming_language_trait.body, programming_language_id: @programming_language_trait.programming_language_id, trait_id: @programming_language_trait.trait_id } }, as: :json
    assert_response :success
  end

  test "should destroy programming_language_trait" do
    assert_difference("ProgrammingLanguageTrait.count", -1) do
      delete programming_language_trait_url(@programming_language_trait), as: :json
    end

    assert_response :no_content
  end
end
