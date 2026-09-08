require "rails_helper"

RSpec.describe "CareerDashboard", type: :request do
  it "requires authentication" do
    get career_dashboard_path

    expect(response).to redirect_to(new_user_session_path)
  end

  it "renders skills ordered by category then level" do
    user = create(:user)
    backend = create(:skill, name: "Rails", category: "Backend")
    db_skill = create(:skill, name: "PostgreSQL", category: "Database")

    create(:user_skill, user: user, skill: db_skill, level: 6, confidence: 6)
    create(:user_skill, user: user, skill: backend, level: 9, confidence: 8)

    sign_in user
    get career_dashboard_path

    expect(response).to have_http_status(:ok)
    expect(response.body.index("Backend")).to be < response.body.index("Database")
  end

  it "renders higher level skills first within the same category" do
    user = create(:user)
    low_skill = create(:skill, name: "Ruby", category: "Backend")
    high_skill = create(:skill, name: "Rails", category: "Backend")

    create(:user_skill, user: user, skill: low_skill, level: 4, confidence: 5)
    create(:user_skill, user: user, skill: high_skill, level: 8, confidence: 6)

    sign_in user
    get career_dashboard_path

    expect(response).to have_http_status(:ok)
    expect(response.body.index("Rails")).to be < response.body.index("Ruby")
  end
end
