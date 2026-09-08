require "test_helper"

class UserSkillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @user_skill = user_skills(:one)
  end

  test "should redirect create when unauthenticated" do
    post user_skills_url, params: { user_skill: { skill_id: skills(:two).id, level: 6, confidence: 7 } }

    assert_redirected_to new_user_session_url
  end

  test "should create user_skill for signed-in user" do
    sign_in @user

    assert_difference("UserSkill.count") do
      post user_skills_url, params: { user_skill: { skill_id: skills(:two).id, level: 6, confidence: 7 } }
    end

    assert_redirected_to career_dashboard_url
    assert_equal @user.id, UserSkill.last.user_id
  end

  test "should get edit for the signed-in user's skill" do
    sign_in @user

    get edit_user_skill_url(@user_skill)

    assert_response :success
  end

  test "should update user_skill" do
    sign_in @user

    patch user_skill_url(@user_skill), params: { user_skill: { skill_id: @user_skill.skill_id, level: 8, confidence: 9 } }

    assert_redirected_to career_dashboard_url
    assert_equal 8, @user_skill.reload.level
    assert_equal 9, @user_skill.confidence
  end
end
