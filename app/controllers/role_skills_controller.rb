class RoleSkillsController < ApplicationController
  before_action :set_role_skill, only: %i[show edit update destroy]

  def index
    @role_skills = RoleSkill.includes(:role, :skill).order("roles.title ASC, skills.name ASC").references(:role, :skill)
  end

  def show
  end

  def new
    @role_skill = RoleSkill.new
  end

  def edit
  end

  def create
    @role_skill = RoleSkill.new(role_skill_params)

    if @role_skill.save
      redirect_to @role_skill, notice: "Role skill was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @role_skill.update(role_skill_params)
      redirect_to @role_skill, notice: "Role skill was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @role_skill.destroy!
    redirect_to role_skills_path, notice: "Role skill was successfully destroyed.", status: :see_other
  end

  private

  def set_role_skill
    @role_skill = RoleSkill.find(params.expect(:id))
  end

  def role_skill_params
    params.expect(role_skill: [ :role_id, :skill_id, :required_level, :importance ])
  end
end
