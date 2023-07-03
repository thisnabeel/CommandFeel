require "test_helper"

class AlgorithmsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @algorithm = algorithms(:one)
  end

  test "should get index" do
    get algorithms_url, as: :json
    assert_response :success
  end

  test "should create algorithm" do
    assert_difference("Algorithm.count") do
      post algorithms_url, params: { algorithm: { description: @algorithm.description, difficulty: @algorithm.difficulty, expected: @algorithm.expected, title: @algorithm.title } }, as: :json
    end

    assert_response :created
  end

  test "should show algorithm" do
    get algorithm_url(@algorithm), as: :json
    assert_response :success
  end

  test "should update algorithm" do
    patch algorithm_url(@algorithm), params: { algorithm: { description: @algorithm.description, difficulty: @algorithm.difficulty, expected: @algorithm.expected, title: @algorithm.title } }, as: :json
    assert_response :success
  end

  test "should destroy algorithm" do
    assert_difference("Algorithm.count", -1) do
      delete algorithm_url(@algorithm), as: :json
    end

    assert_response :no_content
  end
end
