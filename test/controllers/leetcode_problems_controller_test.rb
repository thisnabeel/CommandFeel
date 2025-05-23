require "test_helper"

class LeetcodeProblemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @leetcode_problem = leetcode_problems(:one)
  end

  test "should get index" do
    get leetcode_problems_url, as: :json
    assert_response :success
  end

  test "should create leetcode_problem" do
    assert_difference("LeetcodeProblem.count") do
      post leetcode_problems_url, params: { leetcode_problem: { description: @leetcode_problem.description, difficulty: @leetcode_problem.difficulty, title: @leetcode_problem.title, topics: @leetcode_problem.topics, url: @leetcode_problem.url } }, as: :json
    end

    assert_response :created
  end

  test "should show leetcode_problem" do
    get leetcode_problem_url(@leetcode_problem), as: :json
    assert_response :success
  end

  test "should update leetcode_problem" do
    patch leetcode_problem_url(@leetcode_problem), params: { leetcode_problem: { description: @leetcode_problem.description, difficulty: @leetcode_problem.difficulty, title: @leetcode_problem.title, topics: @leetcode_problem.topics, url: @leetcode_problem.url } }, as: :json
    assert_response :success
  end

  test "should destroy leetcode_problem" do
    assert_difference("LeetcodeProblem.count", -1) do
      delete leetcode_problem_url(@leetcode_problem), as: :json
    end

    assert_response :no_content
  end
end
