require "rails_helper"

RSpec.describe "UserSkills", type: :request do
  let(:user) { create(:user) }
  let(:skill) { create(:skill, name: "Ruby", category: "Backend") }

  describe "authentication" do
    it "redirects unauthenticated users" do
      post user_skills_path, params: { user_skill: { skill_id: skill.id, level: 7, confidence: 6 } }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "adding and updating assessments" do
    before { sign_in user }

    it "adds a skill assessment" do
      expect do
        post user_skills_path, params: { user_skill: { skill_id: skill.id, level: 7, confidence: 6 } }
      end.to change(user.user_skills, :count).by(1)

      assessment = user.user_skills.last
      expect(response).to redirect_to(career_dashboard_path)
      expect(assessment.level).to eq(7)
      expect(assessment.confidence).to eq(6)
    end

    it "re-renders dashboard when add skill assessment is invalid" do
      create(:career_profile, user: user)

      post user_skills_path, params: { user_skill: { skill_id: skill.id, level: nil, confidence: 6 } }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Career Gym")
      expect(response.body).to include("Level can&#39;t be blank")
    end

    it "updates a skill assessment" do
      assessment = create(:user_skill, user: user, skill: skill, level: 4, confidence: 4)

      patch user_skill_path(assessment), params: { user_skill: { skill_id: skill.id, level: 8, confidence: 9 } }

      expect(response).to redirect_to(career_dashboard_path)
      expect(assessment.reload.level).to eq(8)
      expect(assessment.confidence).to eq(9)
    end

    it "re-renders edit when update is invalid" do
      assessment = create(:user_skill, user: user, skill: skill, level: 4, confidence: 4)

      patch user_skill_path(assessment), params: { user_skill: { skill_id: skill.id, level: 11, confidence: 9 } }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Edit Skill Assessment")
      expect(response.body).to include("Level must be less than or equal to 10")
    end
  end

  describe "authorization" do
    it "prevents modifying another user's skill assessment" do
      owner = create(:user)
      intruder = create(:user)
      assessment = create(:user_skill, user: owner)

      sign_in intruder

      patch user_skill_path(assessment), params: { user_skill: { skill_id: assessment.skill_id, level: 9, confidence: 9 } }

      expect(response).to have_http_status(:not_found)
      expect(assessment.reload.level).not_to eq(9)
    end
  end
end
