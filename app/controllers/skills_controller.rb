class SkillsController < ApplicationController
  before_action :set_skill, only: %i[ show edit update destroy ]

  # GET /skills
  def index
    @skills = Skill.all
  end

  # GET /skills/1
  def show
  end

  # GET /skills/new
  def new
    @skill = Skill.new
  end

  # GET /skills/1/edit
  def edit
  end

  # POST /skills
  def create
    @skill = Skill.new(skill_params)

    if @skill.save
      redirect_to @skill, notice: "Skill was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /skills/1
  def update
    if @skill.update(skill_params)
      redirect_to @skill, notice: "Skill was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /skills/1
  def destroy
    @skill.destroy!
    redirect_to skills_path, notice: "Skill was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skill
      @skill = Skill.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def skill_params
      params.expect(skill: [ :name, :category ])
    end
end
