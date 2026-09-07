require "test_helper"

class JobSillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @job_sill = job_sills(:one)
  end

  test "should get index" do
    get job_sills_url
    assert_response :success
  end

  test "should get new" do
    get new_job_sill_url
    assert_response :success
  end

  test "should create job_sill" do
    assert_difference("JobSill.count") do
      post job_sills_url, params: { job_sill: { importance: @job_sill.importance, job: @job_sill.job, skill: @job_sill.skill } }
    end

    assert_redirected_to job_sill_url(JobSill.last)
  end

  test "should show job_sill" do
    get job_sill_url(@job_sill)
    assert_response :success
  end

  test "should get edit" do
    get edit_job_sill_url(@job_sill)
    assert_response :success
  end

  test "should update job_sill" do
    patch job_sill_url(@job_sill), params: { job_sill: { importance: @job_sill.importance, job: @job_sill.job, skill: @job_sill.skill } }
    assert_redirected_to job_sill_url(@job_sill)
  end

  test "should destroy job_sill" do
    assert_difference("JobSill.count", -1) do
      delete job_sill_url(@job_sill)
    end

    assert_redirected_to job_sills_url
  end
end
