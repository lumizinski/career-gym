require "rails_helper"

RSpec.describe JobSkill, type: :model do
  it "belongs to job and skill" do
    job_association = described_class.reflect_on_association(:job)
    skill_association = described_class.reflect_on_association(:skill)

    expect(job_association.macro).to eq(:belongs_to)
    expect(skill_association.macro).to eq(:belongs_to)
  end

  it "requires a required_level between 1 and 10" do
    job_skill = build(:job_skill, required_level: 11)

    expect(job_skill).not_to be_valid
    expect(job_skill.errors[:required_level]).to be_present
  end

  it "requires a supported importance" do
    job_skill = build(:job_skill, importance: "Urgent")

    expect(job_skill).not_to be_valid
    expect(job_skill.errors[:importance]).to include("is not included in the list")
  end

  it "validates one required skill per job" do
    job = create(:job)
    skill = create(:skill)
    create(:job_skill, job: job, skill: skill)

    duplicate = build(:job_skill, job: job, skill: skill)

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:skill_id]).to include("has already been taken")
  end
end
