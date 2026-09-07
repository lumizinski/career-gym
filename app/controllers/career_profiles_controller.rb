class CareerProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_career_profile, only: %i[edit update]

  def show
    @career_profile = current_user.career_profile
  end

  def new
    redirect_to edit_career_profile_path and return if current_user.career_profile.present?

    @career_profile = current_user.build_career_profile
  end

  def create
    @career_profile = current_user.build_career_profile(career_profile_params)

    if @career_profile.save
      redirect_to career_dashboard_path, notice: "Career profile was successfully created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @career_profile.update(career_profile_params)
      redirect_to career_dashboard_path, notice: "Career profile was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_career_profile
    @career_profile = current_user.career_profile
    return if @career_profile.present?

    redirect_to new_career_profile_path, alert: "Create your career profile first."
    return
  end

  def career_profile_params
    params.expect(career_profile: [:current_role, :years_of_experience, :target_role, :target_market, :goals])
  end
end
