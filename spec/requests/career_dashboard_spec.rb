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
    get career_dashboard_path, headers: { "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36" }

    expect(response).to have_http_status(:ok)
    expect(response.body.index("Backend")).to be < response.body.index("Database")
  end
end
