class UserSkillsController < ApplicationController
  before_action :set_user_skill, only: %i[ show edit update destroy ]

  # GET /user_skills
  def index
    @user_skills = UserSkill.all
  end

  # GET /user_skills/1
  def show
  end

  # GET /user_skills/new
  def new
    @user_skill = UserSkill.new
  end

  # GET /user_skills/1/edit
  def edit
  end

  # POST /user_skills
  def create
    @user_skill = UserSkill.new(user_skill_params)

    if @user_skill.save
      redirect_to @user_skill, notice: "User skill was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /user_skills/1
  def update
    if @user_skill.update(user_skill_params)
      redirect_to @user_skill, notice: "User skill was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /user_skills/1
  def destroy
    @user_skill.destroy!
    redirect_to user_skills_path, notice: "User skill was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_skill
      @user_skill = UserSkill.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_skill_params
      params.expect(user_skill: [ :user_id, :skill_id, :level, :confidence ])
    end
end
