require "rails_helper"

RSpec.describe "CareerProfiles", type: :request do
  let(:user) { create(:user) }

  describe "authentication" do
    it "redirects unauthenticated users" do
      get new_career_profile_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "CRUD" do
    before { sign_in user }

    it "creates a career profile" do
      expect do
        post career_profile_path, params: {
          career_profile: {
            current_role: "Senior Backend Engineer",
            years_of_experience: 8,
            target_role: "Staff Backend Engineer",
            target_market: "International Remote",
            goals: "Grow architecture ownership"
          }
        }
      end.to change(CareerProfile, :count).by(1)

      expect(response).to redirect_to(career_dashboard_path)
      expect(user.reload.career_profile.current_role).to eq("Senior Backend Engineer")
    end

    it "updates a career profile" do
      profile = create(:career_profile, user: user, current_role: "Backend Engineer")

      patch career_profile_path, params: {
        career_profile: { current_role: "Senior Backend Engineer", years_of_experience: 9, target_role: profile.target_role, target_market: profile.target_market, goals: profile.goals }
      }

      expect(response).to redirect_to(career_dashboard_path)
      expect(profile.reload.current_role).to eq("Senior Backend Engineer")
      expect(profile.years_of_experience).to eq(9)
    end
  end

  describe "authorization" do
    it "uses the signed-in user's profile only" do
      user_one = create(:user)
      user_two = create(:user)
      create(:career_profile, user: user_one, current_role: "User One")
      create(:career_profile, user: user_two, current_role: "User Two")

      sign_in user_one
      get edit_career_profile_path

      expect(response.body).to include("User One")
      expect(response.body).not_to include("User Two")
    end
  end
end
