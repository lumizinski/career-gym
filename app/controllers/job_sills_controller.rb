class JobSillsController < ApplicationController
  before_action :set_job_sill, only: %i[ show edit update destroy ]

  # GET /job_sills
  def index
    @job_sills = JobSill.all
  end

  # GET /job_sills/1
  def show
  end

  # GET /job_sills/new
  def new
    @job_sill = JobSill.new
  end

  # GET /job_sills/1/edit
  def edit
  end

  # POST /job_sills
  def create
    @job_sill = JobSill.new(job_sill_params)

    if @job_sill.save
      redirect_to @job_sill, notice: "Job sill was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /job_sills/1
  def update
    if @job_sill.update(job_sill_params)
      redirect_to @job_sill, notice: "Job sill was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /job_sills/1
  def destroy
    @job_sill.destroy!
    redirect_to job_sills_path, notice: "Job sill was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_sill
      @job_sill = JobSill.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def job_sill_params
      params.expect(job_sill: [ :job, :skill, :importance ])
    end
end
