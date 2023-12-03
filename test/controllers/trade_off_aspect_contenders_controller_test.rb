require "test_helper"

class TradeOffAspectContendersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trade_off_aspect_contender = trade_off_aspect_contenders(:one)
  end

  test "should get index" do
    get trade_off_aspect_contenders_url, as: :json
    assert_response :success
  end

  test "should create trade_off_aspect_contender" do
    assert_difference("TradeOffAspectContender.count") do
      post trade_off_aspect_contenders_url, params: { trade_off_aspect_contender: { body: @trade_off_aspect_contender.body, trade_off_aspect_id: @trade_off_aspect_contender.trade_off_aspect_id, trade_off_contender_id: @trade_off_aspect_contender.trade_off_contender_id } }, as: :json
    end

    assert_response :created
  end

  test "should show trade_off_aspect_contender" do
    get trade_off_aspect_contender_url(@trade_off_aspect_contender), as: :json
    assert_response :success
  end

  test "should update trade_off_aspect_contender" do
    patch trade_off_aspect_contender_url(@trade_off_aspect_contender), params: { trade_off_aspect_contender: { body: @trade_off_aspect_contender.body, trade_off_aspect_id: @trade_off_aspect_contender.trade_off_aspect_id, trade_off_contender_id: @trade_off_aspect_contender.trade_off_contender_id } }, as: :json
    assert_response :success
  end

  test "should destroy trade_off_aspect_contender" do
    assert_difference("TradeOffAspectContender.count", -1) do
      delete trade_off_aspect_contender_url(@trade_off_aspect_contender), as: :json
    end

    assert_response :no_content
  end
end
