require "test_helper"

class ProofLinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @proof_link = proof_links(:one)
  end

  test "should get index" do
    get proof_links_url, as: :json
    assert_response :success
  end

  test "should create proof_link" do
    assert_difference("ProofLink.count") do
      post proof_links_url, params: { proof_link: { description: @proof_link.description, proof_id: @proof_link.proof_id, title: @proof_link.title, url: @proof_link.url, user_id: @proof_link.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show proof_link" do
    get proof_link_url(@proof_link), as: :json
    assert_response :success
  end

  test "should update proof_link" do
    patch proof_link_url(@proof_link), params: { proof_link: { description: @proof_link.description, proof_id: @proof_link.proof_id, title: @proof_link.title, url: @proof_link.url, user_id: @proof_link.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy proof_link" do
    assert_difference("ProofLink.count", -1) do
      delete proof_link_url(@proof_link), as: :json
    end

    assert_response :no_content
  end
end
