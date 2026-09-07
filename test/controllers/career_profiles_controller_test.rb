require "test_helper"

class CareerProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @career_profile = career_profiles(:one)
  end

  test "should get index" do
    get career_profiles_url
    assert_response :success
  end

  test "should get new" do
    get new_career_profile_url
    assert_response :success
  end

  test "should create career_profile" do
    assert_difference("CareerProfile.count") do
      post career_profiles_url, params: { career_profile: { current_role: @career_profile.current_role, goals: @career_profile.goals, target_market: @career_profile.target_market, target_role: @career_profile.target_role, user_id: @career_profile.user_id, years_of_experience: @career_profile.years_of_experience } }
    end

    assert_redirected_to career_profile_url(CareerProfile.last)
  end

  test "should show career_profile" do
    get career_profile_url(@career_profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_career_profile_url(@career_profile)
    assert_response :success
  end

  test "should update career_profile" do
    patch career_profile_url(@career_profile), params: { career_profile: { current_role: @career_profile.current_role, goals: @career_profile.goals, target_market: @career_profile.target_market, target_role: @career_profile.target_role, user_id: @career_profile.user_id, years_of_experience: @career_profile.years_of_experience } }
    assert_redirected_to career_profile_url(@career_profile)
  end

  test "should destroy career_profile" do
    assert_difference("CareerProfile.count", -1) do
      delete career_profile_url(@career_profile)
    end

    assert_redirected_to career_profiles_url
  end
end
