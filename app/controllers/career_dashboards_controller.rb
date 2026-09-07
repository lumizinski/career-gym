class CareerDashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @career_profile = current_user.career_profile
    @user_skills = current_user.user_skills.includes(:skill)
      .joins(:skill)
      .order("skills.category ASC, user_skills.level DESC, skills.name ASC")
    @skills_by_category = @user_skills.group_by { |user_skill| user_skill.skill.category }

    @user_skill = current_user.user_skills.build
    @available_skills = Skill.where.not(id: current_user.user_skills.select(:skill_id)).order(:category, :name)
  end
end
