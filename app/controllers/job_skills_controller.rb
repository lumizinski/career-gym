class JobSkillsController < ApplicationController
  before_action :set_job_skill, only: %i[show edit update destroy]

  def index
    @job_skills = JobSkill.all
  end

  def show
  end

  def new
    @job_skill = JobSkill.new
  end

  def edit
  end

  def create
    @job_skill = JobSkill.new(job_skill_params)

    if @job_skill.save
      redirect_to @job_skill, notice: "Job skill was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @job_skill.update(job_skill_params)
      redirect_to @job_skill, notice: "Job skill was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @job_skill.destroy!
    redirect_to job_skills_path, notice: "Job skill was successfully destroyed.", status: :see_other
  end

  private

  def set_job_skill
    @job_skill = JobSkill.find(params.expect(:id))
  end

  def job_skill_params
    params.expect(job_skill: [:job, :skill, :importance])
  end
end
