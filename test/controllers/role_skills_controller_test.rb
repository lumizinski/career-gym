require "test_helper"

class RoleSkillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @role_skill = role_skills(:one)
  end

  test "should get index" do
    get role_skills_url
    assert_response :success
  end

  test "should get new" do
    get new_role_skill_url
    assert_response :success
  end

  test "should create role_skill" do
    assert_difference("RoleSkill.count") do
      post role_skills_url, params: {
        role_skill: {
          role_id: roles(:two).id,
          skill_id: skills(:one).id,
          required_level: 6,
          importance: "High"
        }
      }
    end

    assert_redirected_to role_skill_url(RoleSkill.last)
  end

  test "should show role_skill" do
    get role_skill_url(@role_skill)
    assert_response :success
  end

  test "should get edit" do
    get edit_role_skill_url(@role_skill)
    assert_response :success
  end

  test "should update role_skill" do
    patch role_skill_url(@role_skill), params: {
      role_skill: {
        role_id: @role_skill.role_id,
        skill_id: @role_skill.skill_id,
        required_level: 8,
        importance: @role_skill.importance
      }
    }
    assert_redirected_to role_skill_url(@role_skill)
  end

  test "should destroy role_skill" do
    assert_difference("RoleSkill.count", -1) do
      delete role_skill_url(@role_skill)
    end

    assert_redirected_to role_skills_url
  end
end
