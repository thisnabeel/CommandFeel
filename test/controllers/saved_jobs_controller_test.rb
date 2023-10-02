require "test_helper"

class SavedJobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @saved_job = saved_jobs(:one)
  end

  test "should get index" do
    get saved_jobs_url, as: :json
    assert_response :success
  end

  test "should create saved_job" do
    assert_difference("SavedJob.count") do
      post saved_jobs_url, params: { saved_job: { company: @saved_job.company, jd: @saved_job.jd, jd_link: @saved_job.jd_link, position: @saved_job.position, skills: @saved_job.skills, stage: @saved_job.stage, title: @saved_job.title, user_id: @saved_job.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show saved_job" do
    get saved_job_url(@saved_job), as: :json
    assert_response :success
  end

  test "should update saved_job" do
    patch saved_job_url(@saved_job), params: { saved_job: { company: @saved_job.company, jd: @saved_job.jd, jd_link: @saved_job.jd_link, position: @saved_job.position, skills: @saved_job.skills, stage: @saved_job.stage, title: @saved_job.title, user_id: @saved_job.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy saved_job" do
    assert_difference("SavedJob.count", -1) do
      delete saved_job_url(@saved_job), as: :json
    end

    assert_response :no_content
  end
end
