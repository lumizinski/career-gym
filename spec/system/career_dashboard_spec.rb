require "rails_helper"

RSpec.describe "Career dashboard", type: :system do
  before { driven_by(:rack_test) }

  it "shows the user's summary, profile, grouped skills, and ordered gaps" do
    user = create(:user)
    create(:career_profile, user: user)

    rails = create(:skill, name: "Rails", category: "Backend")
    ruby = create(:skill, name: "Ruby", category: "Backend")
    system_design = create(:skill, name: "System Design", category: "Architecture")
    postgres = create(:skill, name: "PostgreSQL", category: "Database")

    create(:user_skill, user: user, skill: system_design, level: 2, confidence: 3)
    create(:user_skill, user: user, skill: postgres, level: 6, confidence: 5)
    create(:user_skill, user: user, skill: rails, level: 9, confidence: 9)
    create(:user_skill, user: user, skill: ruby, level: 8, confidence: 8)

    login_as user, scope: :user

    visit "/dashboard"

    expect(page).to have_text("Senior Backend Engineer")
    expect(page).to have_text("→ Staff Backend Engineer")
    expect(page).to have_text("Skills assessed 4")
    expect(page).to have_text("Average level 6.3/10")
    expect(page).to have_text("Skill gaps 2")
    expect(page).to have_text("Profile Complete")

    within("#career-profile") do
      expect(page).to have_text("Current role")
      expect(page).to have_text("Target market")
      expect(page).to have_link("Edit Profile", href: edit_career_profile_path)
    end

    within("#skills") do
      expect(page).to have_text("Backend")
      expect(page).to have_text("Architecture")
      expect(page).to have_text("Database")
      expect(page).to have_text("Rails")
      expect(page).to have_text("Ruby")
      expect(page).to have_text("Confidence: High")
      expect(page).to have_text("Confidence: Medium")
      expect(page.text.index("Backend")).to be < page.text.index("Database")
    end

    within("#skill-gaps") do
      expect(page).to have_text("System Design")
      expect(page).to have_text("PostgreSQL")
      expect(page.text.index("System Design")).to be < page.text.index("PostgreSQL")
    end
  end

  it "prompts the user to create a profile when one does not exist" do
    user = create(:user)

    login_as user, scope: :user

    visit "/dashboard"

    within("#career-profile") do
      expect(page).to have_text("You have not created your career profile yet.")
      expect(page).to have_link("Create Career Profile", href: new_career_profile_path)
    end
  end

  it "shows engineering labs and proof of work summary on the dashboard" do
    user = create(:user)
    postgres = create(:skill, name: "PostgreSQL", category: "Database")
    lab = create(:engineering_lab, user: user, skill: postgres, title: "PostgreSQL Query Optimization", status: :completed)
    create(:proof_of_work, user: user, engineering_lab: lab, proof_type: :github_repository)
    create(:proof_of_work, user: user, engineering_lab: lab, proof_type: :benchmark, title: "Benchmark results")

    login_as user, scope: :user

    visit "/dashboard"

    within("#engineering-labs") do
      expect(page).to have_text("Engineering Labs")
      expect(page).to have_text("1 completed")
      expect(page).to have_link("View Labs", href: labs_path)
    end

    within("#proof-of-work") do
      expect(page).to have_text("Proof of Work")
      expect(page).to have_text("2 pieces of evidence")
      expect(page).to have_text("1 GitHub Repository")
      expect(page).to have_text("1 Benchmark")
      expect(page).to have_link("View Proof of Work", href: proof_of_works_path)
    end
  end
end
