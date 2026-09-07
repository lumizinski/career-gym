class UserSkillsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_skill, only: %i[edit update]
  before_action :set_available_skills, only: %i[create edit update]

  def create
    @user_skill = current_user.user_skills.build(user_skill_params)

    if @user_skill.save
      redirect_to career_dashboard_path, notice: "Skill assessment was successfully added."
    else
      @career_profile = current_user.career_profile
      @user_skills = ordered_user_skills
      @skills_by_category = @user_skills.group_by { |skill| skill.skill.category }
      render "career_dashboards/show", status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @user_skill.update(user_skill_params)
      redirect_to career_dashboard_path, notice: "Skill assessment was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_user_skill
    @user_skill = current_user.user_skills.includes(:skill).find(params.expect(:id))
  end

  def set_available_skills
    taken_skill_ids = current_user.user_skills.where.not(id: @user_skill&.id).select(:skill_id)
    available_skills = Skill.where.not(id: taken_skill_ids)
    available_skills = available_skills.or(Skill.where(id: @user_skill.skill_id)) if @user_skill&.skill_id

    @available_skills = available_skills.order(:category, :name)
  end

  def ordered_user_skills
    current_user.user_skills.includes(:skill).joins(:skill).order("skills.category ASC, user_skills.level DESC, skills.name ASC")
  end

  def user_skill_params
    params.expect(user_skill: [:skill_id, :level, :confidence])
  end
end
