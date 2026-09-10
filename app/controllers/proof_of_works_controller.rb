class ProofOfWorksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lab, only: %i[new create]
  before_action :require_completed_lab!, only: %i[new create]
  before_action :set_proof_of_work, only: %i[show edit update destroy]

  def index
    @proof_groups = current_user.proof_of_works.includes(engineering_lab: :skill).recent_first.group_by(&:skill)
  end

  def show
  end

  def new
    @proof_of_work = @lab.proof_of_works.build(
      user: current_user,
      title: @lab.title,
      description: @lab.description
    )
  end

  def create
    @proof_of_work = @lab.proof_of_works.build(proof_of_work_params)
    @proof_of_work.user = current_user

    if @proof_of_work.save
      redirect_to proof_of_work_path(@proof_of_work), notice: "Proof of work added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @proof_of_work.update(proof_of_work_params)
      redirect_to proof_of_work_path(@proof_of_work), notice: "Proof of work updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    lab = @proof_of_work.engineering_lab
    @proof_of_work.destroy

    redirect_to lab_path(lab), notice: "Proof of work removed."
  end

  private

  def set_lab
    @lab = current_user.engineering_labs.includes(:skill, :proof_of_works).find(params.expect(:lab_id))
  end

  def require_completed_lab!
    return if @lab.completed?

    redirect_to lab_path(@lab), alert: "Complete the lab before adding proof of work."
  end

  def set_proof_of_work
    @proof_of_work = current_user.proof_of_works.includes(engineering_lab: :skill).find(params.expect(:id))
  end

  def proof_of_work_params
    params.expect(proof_of_work: [ :title, :description, :proof_type, :url ])
  end
end
