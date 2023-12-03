require "test_helper"

class TradeOffsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trade_off = trade_offs(:one)
  end

  test "should get index" do
    get trade_offs_url, as: :json
    assert_response :success
  end

  test "should create trade_off" do
    assert_difference("TradeOff.count") do
      post trade_offs_url, params: { trade_off: { header: @trade_off.header, position: @trade_off.position, title: @trade_off.title, trade_off_id: @trade_off.trade_off_id } }, as: :json
    end

    assert_response :created
  end

  test "should show trade_off" do
    get trade_off_url(@trade_off), as: :json
    assert_response :success
  end

  test "should update trade_off" do
    patch trade_off_url(@trade_off), params: { trade_off: { header: @trade_off.header, position: @trade_off.position, title: @trade_off.title, trade_off_id: @trade_off.trade_off_id } }, as: :json
    assert_response :success
  end

  test "should destroy trade_off" do
    assert_difference("TradeOff.count", -1) do
      delete trade_off_url(@trade_off), as: :json
    end

    assert_response :no_content
  end
end
