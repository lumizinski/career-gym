class CareerProfilesController < ApplicationController
  before_action :set_career_profile, only: %i[ show edit update destroy ]

  # GET /career_profiles
  def index
    @career_profiles = CareerProfile.all
  end

  # GET /career_profiles/1
  def show
  end

  # GET /career_profiles/new
  def new
    @career_profile = CareerProfile.new
  end

  # GET /career_profiles/1/edit
  def edit
  end

  # POST /career_profiles
  def create
    @career_profile = CareerProfile.new(career_profile_params)

    if @career_profile.save
      redirect_to @career_profile, notice: "Career profile was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /career_profiles/1
  def update
    if @career_profile.update(career_profile_params)
      redirect_to @career_profile, notice: "Career profile was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /career_profiles/1
  def destroy
    @career_profile.destroy!
    redirect_to career_profiles_path, notice: "Career profile was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_career_profile
      @career_profile = CareerProfile.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def career_profile_params
      params.expect(career_profile: [ :user_id, :current_role, :years_of_experience, :target_role, :target_market, :goals ])
    end
end
