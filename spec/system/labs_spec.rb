require "rails_helper"

RSpec.describe "Engineering labs", type: :system do
  before { driven_by(:rack_test) }

  it "lets a user create a lab from a training item and see it from training" do
    user = create(:user)
    skill = create(:skill, name: "PostgreSQL", category: "Database")
    plan = create(:training_plan, user: user)
    item = create(
      :training_item,
      training_plan: plan,
      skill: skill,
      title: "Run a PostgreSQL query optimization experiment",
      description: "Investigate the performance impact of indexes with EXPLAIN ANALYZE."
    )

    login_as user, scope: :user

    visit training_index_path
    click_link "Create Lab"

    expect(page).to have_text("Create Engineering Lab")
    fill_in "Title", with: "PostgreSQL Query Optimization Experiment"
    fill_in "Description", with: "Hands-on database performance workout."
    fill_in "Objective", with: "Compare indexing strategies using EXPLAIN ANALYZE."
    fill_in "Deliverables (one per line)", with: "Benchmark plan\nEXPLAIN output\nFindings"
    click_button "Create Engineering Lab"

    expect(page).to have_text("Engineering lab created.")
    expect(page).to have_text("PostgreSQL Query Optimization Experiment")

    visit training_index_path
    expect(page).to have_text("🧪 Lab created")
    expect(page).to have_link("Open Lab")
  end
end
