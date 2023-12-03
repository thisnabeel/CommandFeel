require "test_helper"

class TradeOffAspectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trade_off_aspect = trade_off_aspects(:one)
  end

  test "should get index" do
    get trade_off_aspects_url, as: :json
    assert_response :success
  end

  test "should create trade_off_aspect" do
    assert_difference("TradeOffAspect.count") do
      post trade_off_aspects_url, params: { trade_off_aspect: { description: @trade_off_aspect.description, position: @trade_off_aspect.position, title: @trade_off_aspect.title, trade_off_id: @trade_off_aspect.trade_off_id } }, as: :json
    end

    assert_response :created
  end

  test "should show trade_off_aspect" do
    get trade_off_aspect_url(@trade_off_aspect), as: :json
    assert_response :success
  end

  test "should update trade_off_aspect" do
    patch trade_off_aspect_url(@trade_off_aspect), params: { trade_off_aspect: { description: @trade_off_aspect.description, position: @trade_off_aspect.position, title: @trade_off_aspect.title, trade_off_id: @trade_off_aspect.trade_off_id } }, as: :json
    assert_response :success
  end

  test "should destroy trade_off_aspect" do
    assert_difference("TradeOffAspect.count", -1) do
      delete trade_off_aspect_url(@trade_off_aspect), as: :json
    end

    assert_response :no_content
  end
end
