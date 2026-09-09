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

    create(:career_profile, user: viewer, current_role: "Senior Backend Engineer", goals: "Grow into a staff engineer role")
    create(:career_profile, user: other_user, current_role: "Principal Platform Engineer", goals: "Own platform strategy across the company")
    create(:user_skill, user: viewer, skill: viewer_skill, level: 8, confidence: 8)
    create(:user_skill, user: other_user, skill: other_skill, level: 1, confidence: 3)

    sign_in viewer
    get "/dashboard"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Senior Backend Engineer")
    expect(response.body).to include("Grow into a staff engineer role")
    expect(response.body).to include("Ruby")
    expect(response.body).not_to include("Principal Platform Engineer")
    expect(response.body).not_to include("Own platform strategy across the company")
    expect(response.body).not_to include("1/10")
  end

  it "shows training progress summary and highest-priority training skill" do
    user = create(:user)
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    role = create(:role, title: profile.target_role)
    system_design = create(:skill, name: "System Design", category: "Architecture")
    postgres = create(:skill, name: "PostgreSQL", category: "Database")

    create(:role_skill, role: role, skill: system_design, required_level: 8, importance: "Critical")
    create(:role_skill, role: role, skill: postgres, required_level: 7, importance: "High")
    create(:user_skill, user: user, skill: system_design, level: 2, confidence: 4)
    create(:user_skill, user: user, skill: postgres, level: 6, confidence: 7)

    plan = create(:training_plan, user: user)
    create(:training_item, training_plan: plan, skill: system_design, status: :completed, position: 1)
    create(:training_item, training_plan: plan, skill: system_design, status: :in_progress, position: 2)
    create(:training_item, training_plan: plan, skill: postgres, status: :pending, position: 3)

    sign_in user
    get "/dashboard"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Training")
    expect(response.body).to include("1 items completed")
    expect(response.body).to include("1 items in progress")
    expect(response.body).to include("1 items remaining")
    expect(response.body).to include("Highest priority: <strong>System Design</strong>")
    expect(response.body).to include("Continue Training")
  end

  it "shows engineering lab summary and latest lab" do
    user = create(:user)
    postgres = create(:skill, name: "PostgreSQL", category: "Database")
    create(:engineering_lab, user: user, skill: postgres, title: "Completed lab", status: :completed, updated_at: 2.days.ago)
    latest_lab = create(:engineering_lab, user: user, skill: postgres, title: "Latest lab", status: :in_progress, updated_at: 1.hour.ago)

    sign_in user
    get "/dashboard"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Engineering Labs")
    expect(response.body).to include("1 completed")
    expect(response.body).to include("1 in progress")
    expect(response.body).to include("0 pending")
    expect(response.body).to include("Latest: <strong>#{latest_lab.title}</strong>")
    expect(response.body).to include("View Labs")
  end
end
