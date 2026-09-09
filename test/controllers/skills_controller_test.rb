require "test_helper"

class SkillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @skill = skills(:one)
  end

  test "should get index" do
    get skills_url
    assert_response :success
  end

  test "should get new" do
    get new_skill_url
    assert_response :success
  end

  test "should create skill" do
    assert_difference("Skill.count") do
      post skills_url, params: { skill: { category: "Backend", name: "Rails" } }
    end

    assert_redirected_to skill_url(Skill.last)
  end

  test "should show skill" do
    get skill_url(@skill)
    assert_response :success
  end

  test "should get edit" do
    get edit_skill_url(@skill)
    assert_response :success
  end

  test "should update skill" do
    patch skill_url(@skill), params: { skill: { category: @skill.category, name: "Ruby on Rails" } }
    assert_redirected_to skill_url(@skill)
  end

  test "should destroy an unrestricted skill" do
    disposable_skill = Skill.create!(name: "Disposable Skill", category: "Misc")

    assert_difference("Skill.count", -1) do
      delete skill_url(disposable_skill)
    end

    assert_redirected_to skills_url
  end
end
