class CareerDashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @career_profile = current_user.career_profile
    @user_skills = current_user.user_skills.dashboard_order.to_a
    @skills_by_category = @user_skills.group_by { |user_skill| user_skill.skill.category }
    @skill_gaps = @user_skills.select { |user_skill| user_skill.level < UserSkill::SKILL_GAP_LEVEL }
      .sort_by { |user_skill| [ user_skill.level, user_skill.skill.name ] }
    @skills_count = @user_skills.size
    @average_skill_level = @skills_count.positive? ? (@user_skills.sum(&:level).to_f / @skills_count).round(1) : nil

    @user_skill = current_user.user_skills.build
    @available_skills = Skill.where.not(id: current_user.user_skills.select(:skill_id)).order(:category, :name)
  end
end
