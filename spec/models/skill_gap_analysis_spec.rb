require "rails_helper"

RSpec.describe SkillGapAnalysis, type: :model do
  subject(:analysis) { described_class.new(user) }

  let(:user) { create(:user) }

  it "returns no target role when the user has no career profile" do
    expect(analysis.target_role).to be_nil
    expect(analysis.required_skills?).to be(false)
    expect(analysis.biggest_gap).to be_nil
    expect(analysis.critical_gaps).to be_empty
    expect(analysis.other_gaps).to be_empty
    expect(analysis.strengths).to be_empty
  end

  it "returns no required skills when the target role has no requirements" do
    create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    create(:job, title: "Staff Backend Engineer")

    expect(analysis.required_skills?).to be(false)
    expect(analysis.biggest_gap).to be_nil
  end

  it "classifies a skill below the required level as a gap" do
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    job = create(:job, title: profile.target_role)
    skill = create(:skill, name: "System Design", category: "Architecture")
    create(:job_skill, job: job, skill: skill, required_level: 8, importance: "Critical")
    create(:user_skill, user: user, skill: skill, level: 2, confidence: 6)

    expect(analysis.critical_gaps.map { |gap| gap.skill.name }).to eq([ "System Design" ])
  end

  it "treats matching the requirement as a strength" do
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    job = create(:job, title: profile.target_role)
    skill = create(:skill, name: "Ruby", category: "Backend")
    create(:job_skill, job: job, skill: skill, required_level: 7, importance: "Medium")
    create(:user_skill, user: user, skill: skill, level: 7, confidence: 6)

    expect(analysis.other_gaps).to be_empty
    expect(analysis.strengths.map { |gap| gap.skill.name }).to eq([ "Ruby" ])
  end

  it "treats exceeding the requirement as a strength" do
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    job = create(:job, title: profile.target_role)
    skill = create(:skill, name: "Rails", category: "Backend")
    create(:job_skill, job: job, skill: skill, required_level: 7, importance: "Medium")
    create(:user_skill, user: user, skill: skill, level: 9, confidence: 8)

    expect(analysis.strengths.map { |gap| gap.skill.name }).to eq([ "Rails" ])
  end

  it "uses a current level of zero when the user does not have the skill" do
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    job = create(:job, title: profile.target_role)
    skill = create(:skill, name: "Messaging", category: "Architecture")
    create(:job_skill, job: job, skill: skill, required_level: 7, importance: "High")

    gap = analysis.other_gaps.first

    expect(gap.current_level).to eq(0)
    expect(gap.gap).to eq(7)
  end

  it "calculates the gap as required level minus current level" do
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    job = create(:job, title: profile.target_role)
    skill = create(:skill, name: "PostgreSQL", category: "Database")
    create(:job_skill, job: job, skill: skill, required_level: 7, importance: "High")
    create(:user_skill, user: user, skill: skill, level: 6, confidence: 6)

    gap = analysis.other_gaps.first

    expect(gap.gap).to eq(1)
  end

  it "orders gaps by largest gap first" do
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    job = create(:job, title: profile.target_role)
    system_design = create(:skill, name: "System Design", category: "Architecture")
    postgres = create(:skill, name: "PostgreSQL", category: "Database")
    create(:job_skill, job: job, skill: postgres, required_level: 7, importance: "High")
    create(:job_skill, job: job, skill: system_design, required_level: 8, importance: "Critical")
    create(:user_skill, user: user, skill: postgres, level: 6, confidence: 6)
    create(:user_skill, user: user, skill: system_design, level: 2, confidence: 6)

    expect(analysis.biggest_gap.skill.name).to eq("System Design")
    expect(analysis.other_gaps.map { |gap| gap.skill.name }).to eq([ "PostgreSQL" ])
  end

  it "uses importance as a secondary ordering for equal-sized gaps" do
    profile = create(:career_profile, user: user, target_role: "Staff Backend Engineer")
    job = create(:job, title: profile.target_role)
    caching = create(:skill, name: "Caching", category: "Architecture")
    aws = create(:skill, name: "AWS", category: "Cloud")
    create(:job_skill, job: job, skill: aws, required_level: 7, importance: "Medium")
    create(:job_skill, job: job, skill: caching, required_level: 7, importance: "High")
    create(:user_skill, user: user, skill: aws, level: 5, confidence: 5)
    create(:user_skill, user: user, skill: caching, level: 5, confidence: 5)

    expect(analysis.other_gaps.map { |gap| gap.skill.name }).to eq([ "Caching", "AWS" ])
  end
end
