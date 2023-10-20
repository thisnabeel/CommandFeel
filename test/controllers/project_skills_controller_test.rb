require "test_helper"

class ProjectSkillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_skill = project_skills(:one)
  end

  test "should get index" do
    get project_skills_url, as: :json
    assert_response :success
  end

  test "should create project_skill" do
    assert_difference("ProjectSkill.count") do
      post project_skills_url, params: { project_skill: { description: @project_skill.description, position: @project_skill.position, project_id: @project_skill.project_id, skill_id: @project_skill.skill_id, user_id: @project_skill.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show project_skill" do
    get project_skill_url(@project_skill), as: :json
    assert_response :success
  end

  test "should update project_skill" do
    patch project_skill_url(@project_skill), params: { project_skill: { description: @project_skill.description, position: @project_skill.position, project_id: @project_skill.project_id, skill_id: @project_skill.skill_id, user_id: @project_skill.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy project_skill" do
    assert_difference("ProjectSkill.count", -1) do
      delete project_skill_url(@project_skill), as: :json
    end

    assert_response :no_content
  end
end
