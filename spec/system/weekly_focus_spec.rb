require "rails_helper"

RSpec.describe "Weekly focus", type: :system do
  before { driven_by(:rack_test) }

  it "shows top priorities and updates progress when completing a training item" do
    user = create(:user)
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    role = create(:role, title: profile.target_role)
    system_design = create(:skill, name: "System Design", category: "Architecture")

    create(:role_skill, role: role, skill: system_design, required_level: 8, importance: "Critical")
    create(:user_skill, user: user, skill: system_design, level: 2, confidence: 3)

    plan = create(:training_plan, user: user)
    create(:training_item, training_plan: plan, skill: system_design, title: "Design a notification system", status: :pending, position: 1)

    login_as user, scope: :user
    visit focus_path

    expect(page).to have_text("YOUR WEEKLY FOCUS")
    expect(page).to have_text("#1 System Design")
    expect(page).to have_text("Priority: VERY HIGH")
    expect(page).to have_text("0/1 completed")
    expect(page).to have_text("Design a notification system")
    expect(page).to have_button("Start")

    click_button "Start"
    expect(page).to have_text("Training item updated.")
    expect(page).to have_button("Complete")

    click_button "Complete"

    expect(page).to have_text("Training item updated.")
    expect(page).to have_text("1/1 completed")
    expect(page).to have_text("No training activities yet.")
  end
end
