require "rails_helper"

RSpec.describe "Skill gap analysis", type: :system do
  before { driven_by(:rack_test) }

  it "shows the biggest gap, critical gaps, smaller gaps, and strengths" do
    user = create(:user)
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    job = create(:job, title: profile.target_role)

    system_design = create(:skill, name: "System Design", category: "Architecture")
    distributed_systems = create(:skill, name: "Distributed Systems", category: "Architecture")
    postgres = create(:skill, name: "PostgreSQL", category: "Database")
    ruby = create(:skill, name: "Ruby", category: "Backend")

    create(:job_skill, job: job, skill: system_design, required_level: 8, importance: "Critical")
    create(:job_skill, job: job, skill: distributed_systems, required_level: 7, importance: "Critical")
    create(:job_skill, job: job, skill: postgres, required_level: 7, importance: "High")
    create(:job_skill, job: job, skill: ruby, required_level: 7, importance: "Medium")

    create(:user_skill, user: user, skill: system_design, level: 2, confidence: 4)
    create(:user_skill, user: user, skill: distributed_systems, level: 3, confidence: 4)
    create(:user_skill, user: user, skill: postgres, level: 6, confidence: 7)
    create(:user_skill, user: user, skill: ruby, level: 9, confidence: 8)

    login_as user, scope: :user

    visit skill_gaps_path

    expect(page).to have_text("Skill Gap Analysis")
    expect(page).to have_text("Target: Staff Backend Engineer")

    within(".skill-gap-priority") do
      expect(page).to have_text("Your #1 Career Gap")
      expect(page).to have_text("System Design")
      expect(page).to have_text("Current 2/10")
      expect(page).to have_text("Target 8/10")
      expect(page).to have_text("Gap 6 points")
    end

    within("#critical-skill-gaps") do
      expect(page).to have_text("System Design")
      expect(page).to have_text("Distributed Systems")
      expect(page.text.index("System Design")).to be < page.text.index("Distributed Systems")
    end

    within("#other-skill-gaps") do
      expect(page).to have_text("PostgreSQL")
    end

    within("#skill-gap-strengths") do
      expect(page).to have_text("Ruby")
      expect(page).to have_text("Current 9/10")
      expect(page).to have_text("Required 7/10")
    end
  end
end
