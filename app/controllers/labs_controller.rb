class LabsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lab, only: %i[show edit update complete]
  before_action :set_training_item, only: %i[new create]
  before_action :redirect_to_existing_lab, only: :new

  def index
    @labs = current_user.engineering_labs.includes(:skill).ordered
  end

  def show
    @current_skill_level = current_user.user_skills.find_by(skill_id: @lab.skill_id)&.level || 0
    @target_skill_level = target_role_skill&.required_level
    @proof_of_works = @lab.proof_of_works.recent_first
  end

  def new
    @lab = current_user.engineering_labs.build(
      {
        training_item: @training_item,
        skill: @training_item.skill,
        status: :pending
      }.merge(@training_item.suggested_engineering_lab_attributes)
    )
  end

  def create
    @lab = current_user.engineering_labs.build(lab_params)
    @lab.training_item = @training_item
    @lab.skill = @training_item.skill

    if @lab.save
      redirect_to lab_path(@lab), notice: "Engineering lab created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @lab.update(lab_params)
      redirect_to lab_path(@lab), notice: "Engineering lab updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def complete
    if @lab.update(status: :completed)
      redirect_to lab_path(@lab), notice: "Engineering lab completed."
    else
      redirect_to lab_path(@lab), alert: @lab.errors.full_messages.to_sentence
    end
  end

  private

  def set_lab
    @lab = current_user.engineering_labs.includes(:proof_of_works, :skill, training_item: { training_plan: :user }).find(params.expect(:id))
  end

  def set_training_item
    training_items = current_user.training_plan&.training_items&.includes(:skill, :engineering_lab)
    @training_item = training_items&.find(params.expect(:training_item_id))
    raise ActiveRecord::RecordNotFound if @training_item.blank?
  end

  def redirect_to_existing_lab
    return if @training_item.engineering_lab.blank?

    redirect_to lab_path(@training_item.engineering_lab), notice: "Engineering lab already exists."
  end

  def lab_params
    params.expect(engineering_lab: [ :title, :description, :objective, :deliverables_text ])
  end

  def target_role_skill
    role = Role.includes(:role_skills).find_by(title: current_user.career_profile&.target_role)
    role&.role_skills&.find { |role_skill| role_skill.skill_id == @lab.skill_id }
  end
end
