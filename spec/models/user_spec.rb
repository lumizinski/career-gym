require "rails_helper"

RSpec.describe User, type: :model do
  it "has one career profile" do
    association = described_class.reflect_on_association(:career_profile)

    expect(association.macro).to eq(:has_one)
  end

  it "has many user skills" do
    association = described_class.reflect_on_association(:user_skills)

    expect(association.macro).to eq(:has_many)
  end

  it "has many skills through user skills" do
    association = described_class.reflect_on_association(:skills)

    expect(association.macro).to eq(:has_many)
    expect(association.options[:through]).to eq(:user_skills)
  end
end
