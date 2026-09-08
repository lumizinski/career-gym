require "rails_helper"

RSpec.describe UserSkill, type: :model do
  it "belongs to user and skill" do
    user_association = described_class.reflect_on_association(:user)
    skill_association = described_class.reflect_on_association(:skill)

    expect(user_association.macro).to eq(:belongs_to)
    expect(skill_association.macro).to eq(:belongs_to)
  end

  it "requires level and confidence between 1 and 10" do
    user_skill = build(:user_skill, level: 0, confidence: 11)

    expect(user_skill).not_to be_valid
    expect(user_skill.errors[:level]).to be_present
    expect(user_skill.errors[:confidence]).to be_present
  end

  it "validates one assessment per user per skill" do
    user = create(:user)
    skill = create(:skill)
    create(:user_skill, user: user, skill: skill)

    duplicate = build(:user_skill, user: user, skill: skill)

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:skill_id]).to include("has already been taken")
  end
end
