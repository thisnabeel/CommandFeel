require "test_helper"

class CodeFlowElementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @code_flow_element = code_flow_elements(:one)
  end

  test "should get index" do
    get code_flow_elements_url, as: :json
    assert_response :success
  end

  test "should create code_flow_element" do
    assert_difference("CodeFlowElement.count") do
      post code_flow_elements_url, params: { code_flow_element: { category: @code_flow_element.category, title: @code_flow_element.title } }, as: :json
    end

    assert_response :created
  end

  test "should show code_flow_element" do
    get code_flow_element_url(@code_flow_element), as: :json
    assert_response :success
  end

  test "should update code_flow_element" do
    patch code_flow_element_url(@code_flow_element), params: { code_flow_element: { category: @code_flow_element.category, title: @code_flow_element.title } }, as: :json
    assert_response :success
  end

  test "should destroy code_flow_element" do
    assert_difference("CodeFlowElement.count", -1) do
      delete code_flow_element_url(@code_flow_element), as: :json
    end

    assert_response :no_content
  end
end
