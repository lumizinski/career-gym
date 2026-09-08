require "rails_helper"

RSpec.describe "CareerDashboard", type: :request do
  it "redirects unauthenticated users" do
    get "/dashboard"

    expect(response).to redirect_to(new_user_session_path)
  end

  it "allows authenticated users to access /dashboard" do
    user = create(:user)

    sign_in user
    get "/dashboard"

    expect(response).to have_http_status(:ok)
  end

  it "only shows the signed-in user's career information" do
    viewer = create(:user)
    other_user = create(:user)
    viewer_skill = create(:skill, name: "Ruby", category: "Backend")
    other_skill = create(:skill, name: "Terraform", category: "Infrastructure")

    create(:career_profile, user: viewer, current_role: "Senior Backend Engineer")
    create(:career_profile, user: other_user, current_role: "Principal Platform Engineer")
    create(:user_skill, user: viewer, skill: viewer_skill, level: 8, confidence: 8)
    create(:user_skill, user: other_user, skill: other_skill, level: 2, confidence: 3)

    sign_in viewer
    get "/dashboard"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Senior Backend Engineer")
    expect(response.body).to include("Ruby")
    expect(response.body).not_to include("Principal Platform Engineer")
    expect(response.body).not_to include("Terraform")
  end
end
