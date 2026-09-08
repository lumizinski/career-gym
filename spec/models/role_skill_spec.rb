require "rails_helper"

RSpec.describe RoleSkill, type: :model do
  it "belongs to role and skill" do
    role_association = described_class.reflect_on_association(:role)
    skill_association = described_class.reflect_on_association(:skill)

    expect(role_association.macro).to eq(:belongs_to)
    expect(skill_association.macro).to eq(:belongs_to)
  end

  it "requires a required_level between 1 and 10" do
    role_skill = build(:role_skill, required_level: 11)

    expect(role_skill).not_to be_valid
    expect(role_skill.errors[:required_level]).to be_present
  end

  it "requires a supported importance" do
    role_skill = build(:role_skill, importance: "Urgent")

    expect(role_skill).not_to be_valid
    expect(role_skill.errors[:importance]).to include("is not included in the list")
  end

  it "validates one required skill per role" do
    role = create(:role)
    skill = create(:skill)
    create(:role_skill, role: role, skill: skill)

    duplicate = build(:role_skill, role: role, skill: skill)

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:skill_id]).to include("has already been taken")
  end
end
