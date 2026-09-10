require "rails_helper"

RSpec.describe "Proof of work", type: :system do
  before { driven_by(:rack_test) }

  it "lets a user complete a lab, add proof, view it from the lab and index, and open the evidence url" do
    user = create(:user)
    skill = create(:skill, name: "PostgreSQL", category: "Database")
    plan = create(:training_plan, user: user)
    item = create(:training_item, training_plan: plan, skill: skill, status: :completed)
    lab = create(
      :engineering_lab,
      user: user,
      skill: skill,
      training_item: item,
      title: "PostgreSQL Query Optimization Experiment",
      description: "Investigate the impact of different indexes using EXPLAIN ANALYZE.",
      status: :in_progress,
      completed_at: nil
    )

    login_as user, scope: :user

    visit training_index_path
    expect(page).to have_text("🧪 Lab created")
    expect(page).to have_link("Open Lab")

    click_link "Open Lab"
    click_button "Mark as Completed"

    expect(page).to have_text("Engineering lab completed.")
    within("#proof-of-work") do
      expect(page).to have_text("No proof attached yet.")
      click_link "Add Proof of Work"
    end

    fill_in "Title", with: "PostgreSQL Query Optimization Experiment"
    select "Benchmark", from: "Type"
    fill_in "Description", with: "Compared query performance before and after adding a composite index."
    fill_in "URL", with: "https://github.com/example/postgresql-query-optimization"
    click_button "Save"

    expect(page).to have_text("Proof of work added.")
    expect(page).to have_text("Skill:")
    expect(page).to have_text("PostgreSQL")
    expect(find_link("Open Evidence")[:href]).to eq("https://github.com/example/postgresql-query-optimization")

    visit lab_path(lab)
    within("#proof-of-work") do
      expect(page).to have_text("Benchmark")
      expect(page).to have_text("PostgreSQL Query Optimization Experiment")
      expect(page).to have_link("Open")
    end

    visit training_index_path
    expect(page).to have_text("Proof:")
    expect(page).to have_text("✓ Evidence attached")

    visit proof_of_works_path
    expect(page).to have_text("Proof of Work")
    expect(page).to have_text("PostgreSQL")
    expect(page).to have_text("PostgreSQL Query Optimization Experiment")
    click_link "Open"

    expect(page).to have_text("Evidence")
    expect(find_link("Open Evidence")[:href]).to eq("https://github.com/example/postgresql-query-optimization")
  end
end
