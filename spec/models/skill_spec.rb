require "rails_helper"

RSpec.describe Skill, type: :model do
  it "has user skills and users associations" do
    training_items_association = described_class.reflect_on_association(:training_items)
    user_skills_association = described_class.reflect_on_association(:user_skills)
    users_association = described_class.reflect_on_association(:users)

    expect(training_items_association.macro).to eq(:has_many)
    expect(user_skills_association.macro).to eq(:has_many)
    expect(users_association.macro).to eq(:has_many)
    expect(users_association.options[:through]).to eq(:user_skills)
  end

  it "requires name and category" do
    skill = described_class.new

    expect(skill).not_to be_valid
    expect(skill.errors[:name]).to include("can't be blank")
    expect(skill.errors[:category]).to include("can't be blank")
  end

  it "validates unique name within category" do
    create(:skill, name: "Rails", category: "Backend")
    duplicate = build(:skill, name: "Rails", category: "Backend")

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:name]).to include("has already been taken")
  end

  it "validates unique name within category case-insensitively" do
    create(:skill, name: "Rails", category: "Backend")
    duplicate = build(:skill, name: "rails", category: "Backend")

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:name]).to include("has already been taken")
  end
end
