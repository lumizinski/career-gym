require "rails_helper"

RSpec.describe CareerFocus, type: :model do
  subject(:focus) { described_class.new(user) }

  let(:user) { create(:user) }

  it "returns no priorities when the user has no career profile" do
    expect(focus.target_role).to be_nil
    expect(focus.required_skills?).to be(false)
    expect(focus.skills).to be_empty
  end

  it "returns no priorities when the user has no target role" do
    create(:career_profile, user: user, target_role: nil)

    expect(focus.target_role).to be_nil
    expect(focus.required_skills?).to be(false)
    expect(focus.skills).to be_empty
  end

  it "returns no priorities when the target role has no skill requirements" do
    create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    create(:role, title: "Staff Backend Engineer")

    expect(focus.required_skills?).to be(false)
    expect(focus.skills).to be_empty
  end

  it "returns no priorities when there are no gaps" do
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    role = create(:role, title: profile.target_role)
    skill = create(:skill, name: "PostgreSQL", category: "Database")
    create(:role_skill, role: role, skill: skill, required_level: 7, importance: "High")
    create(:user_skill, user: user, skill: skill, level: 7, confidence: 8)

    expect(focus.skills).to be_empty
  end

  it "returns one priority skill when there is one gap" do
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    role = create(:role, title: profile.target_role)
    skill = create(:skill, name: "System Design", category: "Architecture")
    create(:role_skill, role: role, skill: skill, required_level: 8, importance: "Critical")
    create(:user_skill, user: user, skill: skill, level: 2, confidence: 3)

    priority = focus.skills.first

    expect(focus.skills.size).to eq(1)
    expect(priority.skill.name).to eq("System Design")
    expect(priority.current_level).to eq(2)
    expect(priority.target_level).to eq(8)
    expect(priority.gap).to eq(6)
    expect(priority.priority_label).to eq("VERY HIGH")
  end

  it "returns multiple priority skills ordered by score" do
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    role = create(:role, title: profile.target_role)
    system_design = create(:skill, name: "System Design", category: "Architecture")
    distributed = create(:skill, name: "Distributed Systems", category: "Architecture")
    postgres = create(:skill, name: "PostgreSQL", category: "Database")

    create(:role_skill, role: role, skill: system_design, required_level: 8, importance: "Critical")
    create(:role_skill, role: role, skill: distributed, required_level: 7, importance: "High")
    create(:role_skill, role: role, skill: postgres, required_level: 7, importance: "High")

    create(:user_skill, user: user, skill: system_design, level: 2, confidence: 3)
    create(:user_skill, user: user, skill: distributed, level: 3, confidence: 4)
    create(:user_skill, user: user, skill: postgres, level: 6, confidence: 7)

    expect(focus.skills.map { |skill| skill.skill.name }).to eq([ "System Design", "Distributed Systems", "PostgreSQL" ])
  end

  it "orders larger gaps first when other factors are equal" do
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    role = create(:role, title: profile.target_role)
    larger_gap_skill = create(:skill, name: "Messaging", category: "Architecture")
    smaller_gap_skill = create(:skill, name: "Caching", category: "Architecture")

    create(:role_skill, role: role, skill: larger_gap_skill, required_level: 8, importance: "High")
    create(:role_skill, role: role, skill: smaller_gap_skill, required_level: 8, importance: "High")

    create(:user_skill, user: user, skill: larger_gap_skill, level: 2, confidence: 5)
    create(:user_skill, user: user, skill: smaller_gap_skill, level: 5, confidence: 5)

    expect(focus.skills.map { |skill| skill.skill.name }).to eq([ "Messaging", "Caching" ])
  end

  it "prioritizes higher-importance skills for equal gaps and confidence" do
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    role = create(:role, title: profile.target_role)
    critical_skill = create(:skill, name: "Incident Response", category: "Operations")
    low_skill = create(:skill, name: "Compliance", category: "Operations")

    create(:role_skill, role: role, skill: critical_skill, required_level: 7, importance: "Critical")
    create(:role_skill, role: role, skill: low_skill, required_level: 7, importance: "Low")

    create(:user_skill, user: user, skill: critical_skill, level: 4, confidence: 6)
    create(:user_skill, user: user, skill: low_skill, level: 4, confidence: 6)

    expect(focus.skills.map { |skill| skill.skill.name }).to eq([ "Incident Response", "Compliance" ])
  end

  it "prioritizes lower-confidence skills for equal gaps and importance" do
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    role = create(:role, title: profile.target_role)
    low_confidence_skill = create(:skill, name: "System Design", category: "Architecture")
    high_confidence_skill = create(:skill, name: "Distributed Systems", category: "Architecture")

    create(:role_skill, role: role, skill: low_confidence_skill, required_level: 8, importance: "High")
    create(:role_skill, role: role, skill: high_confidence_skill, required_level: 8, importance: "High")

    create(:user_skill, user: user, skill: low_confidence_skill, level: 4, confidence: 2)
    create(:user_skill, user: user, skill: high_confidence_skill, level: 4, confidence: 8)

    expect(focus.skills.map { |skill| skill.skill.name }).to eq([ "System Design", "Distributed Systems" ])
  end

  it "returns a maximum of three priority skills" do
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    role = create(:role, title: profile.target_role)

    4.times do |index|
      skill = create(:skill, name: "Skill #{index}", category: "Category #{index}")
      create(:role_skill, role: role, skill: skill, required_level: 8, importance: "High")
      create(:user_skill, user: user, skill: skill, level: 2 + index, confidence: 4)
    end

    expect(focus.skills.size).to eq(3)
  end

  it "does not present completed items as pending weekly activities" do
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    role = create(:role, title: profile.target_role)
    skill = create(:skill, name: "System Design", category: "Architecture")
    create(:role_skill, role: role, skill: skill, required_level: 8, importance: "Critical")
    create(:user_skill, user: user, skill: skill, level: 2, confidence: 3)
    plan = create(:training_plan, user: user)
    completed_item = create(:training_item, training_plan: plan, skill: skill, status: :completed, position: 1)
    pending_item = create(:training_item, training_plan: plan, skill: skill, status: :pending, position: 2)
    in_progress_item = create(:training_item, training_plan: plan, skill: skill, status: :in_progress, position: 3)

    items = focus.training_items_for(focus.top_skill)

    expect(items).to contain_exactly(pending_item, in_progress_item)
    expect(items).not_to include(completed_item)
  end

  it "isolates progress and activities by user" do
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    role = create(:role, title: profile.target_role)
    skill = create(:skill, name: "System Design", category: "Architecture")
    create(:role_skill, role: role, skill: skill, required_level: 8, importance: "Critical")
    create(:user_skill, user: user, skill: skill, level: 2, confidence: 3)

    user_plan = create(:training_plan, user: user)
    create(:training_item, training_plan: user_plan, skill: skill, status: :pending, position: 1)

    other_user = create(:user)
    other_plan = create(:training_plan, user: other_user)
    create(:training_item, training_plan: other_plan, skill: skill, status: :completed, position: 1)
    other_lab = create(:engineering_lab, user: other_user, skill: skill, status: :completed)
    create(:proof_of_work, user: other_user, engineering_lab: other_lab)

    progress = focus.progress_for(focus.top_skill)

    expect(progress[:training_items_count]).to eq(1)
    expect(progress[:training_items_completed_count]).to eq(0)
    expect(progress[:labs_completed_count]).to eq(0)
    expect(progress[:proof_of_work_count]).to eq(0)
  end
end
