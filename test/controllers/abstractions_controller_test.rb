require "test_helper"

class AbstractionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @abstraction = abstractions(:one)
  end

  test "should get index" do
    get abstractions_url, as: :json
    assert_response :success
  end

  test "should create abstraction" do
    assert_difference("Abstraction.count") do
      post abstractions_url, params: { abstraction: { abstractable_id: @abstraction.abstractable_id, abstractable_type: @abstraction.abstractable_type, article: @abstraction.article, body: @abstraction.body, last_edited_by: @abstraction.last_edited_by, position: @abstraction.position, preview: @abstraction.preview, source_url: @abstraction.source_url } }, as: :json
    end

    assert_response :created
  end

  test "should show abstraction" do
    get abstraction_url(@abstraction), as: :json
    assert_response :success
  end

  test "should update abstraction" do
    patch abstraction_url(@abstraction), params: { abstraction: { abstractable_id: @abstraction.abstractable_id, abstractable_type: @abstraction.abstractable_type, article: @abstraction.article, body: @abstraction.body, last_edited_by: @abstraction.last_edited_by, position: @abstraction.position, preview: @abstraction.preview, source_url: @abstraction.source_url } }, as: :json
    assert_response :success
  end

  test "should destroy abstraction" do
    assert_difference("Abstraction.count", -1) do
      delete abstraction_url(@abstraction), as: :json
    end

    assert_response :no_content
  end
end
