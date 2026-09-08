require "rails_helper"

RSpec.describe "SkillGaps", type: :request do
  it "requires authentication for /skill_gaps" do
    get skill_gaps_path

    expect(response).to redirect_to(new_user_session_path)
  end

  it "shows only the signed-in user's skill gap analysis" do
    viewer = create(:user)
    other_user = create(:user)

    viewer_profile = create(:career_profile, user: viewer, target_role: "Staff Backend Engineer")
    other_profile = create(:career_profile, user: other_user, target_role: "Principal Platform Engineer")

    viewer_job = create(:job, title: viewer_profile.target_role)
    other_job = create(:job, title: other_profile.target_role)

    viewer_skill = create(:skill, name: "System Design", category: "Architecture")
    other_skill = create(:skill, name: "Terraform", category: "Infrastructure")

    create(:job_skill, job: viewer_job, skill: viewer_skill, required_level: 8, importance: "Critical")
    create(:job_skill, job: other_job, skill: other_skill, required_level: 7, importance: "High")
    create(:user_skill, user: viewer, skill: viewer_skill, level: 2, confidence: 5)
    create(:user_skill, user: other_user, skill: other_skill, level: 1, confidence: 4)

    sign_in viewer
    get skill_gaps_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Staff Backend Engineer")
    expect(response.body).to include("System Design")
    expect(response.body).not_to include("Principal Platform Engineer")
    expect(response.body).not_to include("Terraform")
  end
end
