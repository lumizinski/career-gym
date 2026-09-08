require "test_helper"

class CareerProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @career_profile = career_profiles(:one)
  end

  test "should redirect new when unauthenticated" do
    get new_career_profile_url
    assert_redirected_to new_user_session_url
  end

  test "should get new when authenticated and missing a profile" do
    user_without_profile = User.create!(
      email: "new-user@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    sign_in user_without_profile

    get new_career_profile_url

    assert_response :success
  end

  test "should create career_profile for the signed-in user" do
    user_without_profile = User.create!(
      email: "profileless-user@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
    sign_in user_without_profile

    assert_difference("CareerProfile.count") do
      post career_profile_url, params: {
        career_profile: {
          current_role: "Backend Engineer",
          years_of_experience: 5,
          target_role: "Staff Backend Engineer",
          target_market: "International Remote",
          goals: "Grow architecture ownership"
        }
      }
    end

    assert_redirected_to career_dashboard_url
    assert_equal "Backend Engineer", user_without_profile.reload.career_profile.current_role
  end

  test "should get edit for the signed-in user's profile" do
    sign_in @user

    get edit_career_profile_url

    assert_response :success
  end

  test "should update career_profile" do
    sign_in @user

    patch career_profile_url, params: {
      career_profile: {
        current_role: "Principal Backend Engineer",
        years_of_experience: @career_profile.years_of_experience,
        target_role: @career_profile.target_role,
        target_market: @career_profile.target_market,
        goals: @career_profile.goals
      }
    }

    assert_redirected_to career_dashboard_url
    assert_equal "Principal Backend Engineer", @career_profile.reload.current_role
  end
end
