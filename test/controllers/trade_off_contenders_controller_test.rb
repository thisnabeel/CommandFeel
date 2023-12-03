require "test_helper"

class TradeOffContendersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trade_off_contender = trade_off_contenders(:one)
  end

  test "should get index" do
    get trade_off_contenders_url, as: :json
    assert_response :success
  end

  test "should create trade_off_contender" do
    assert_difference("TradeOffContender.count") do
      post trade_off_contenders_url, params: { trade_off_contender: { description: @trade_off_contender.description, position: @trade_off_contender.position, skill_id: @trade_off_contender.skill_id, title: @trade_off_contender.title, trade_off_id: @trade_off_contender.trade_off_id } }, as: :json
    end

    assert_response :created
  end

  test "should show trade_off_contender" do
    get trade_off_contender_url(@trade_off_contender), as: :json
    assert_response :success
  end

  test "should update trade_off_contender" do
    patch trade_off_contender_url(@trade_off_contender), params: { trade_off_contender: { description: @trade_off_contender.description, position: @trade_off_contender.position, skill_id: @trade_off_contender.skill_id, title: @trade_off_contender.title, trade_off_id: @trade_off_contender.trade_off_id } }, as: :json
    assert_response :success
  end

  test "should destroy trade_off_contender" do
    assert_difference("TradeOffContender.count", -1) do
      delete trade_off_contender_url(@trade_off_contender), as: :json
    end

    assert_response :no_content
  end
end
