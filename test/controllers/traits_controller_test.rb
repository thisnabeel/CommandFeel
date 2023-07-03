require "test_helper"

class TraitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trait = traits(:one)
  end

  test "should get index" do
    get traits_url, as: :json
    assert_response :success
  end

  test "should create trait" do
    assert_difference("Trait.count") do
      post traits_url, params: { trait: { description: @trait.description, title: @trait.title } }, as: :json
    end

    assert_response :created
  end

  test "should show trait" do
    get trait_url(@trait), as: :json
    assert_response :success
  end

  test "should update trait" do
    patch trait_url(@trait), params: { trait: { description: @trait.description, title: @trait.title } }, as: :json
    assert_response :success
  end

  test "should destroy trait" do
    assert_difference("Trait.count", -1) do
      delete trait_url(@trait), as: :json
    end

    assert_response :no_content
  end
end
