require "rails_helper"

RSpec.describe Role, type: :model do
  it "has role skills and skills associations" do
    role_skills_association = described_class.reflect_on_association(:role_skills)
    skills_association = described_class.reflect_on_association(:skills)

    expect(role_skills_association.macro).to eq(:has_many)
    expect(skills_association.macro).to eq(:has_many)
    expect(skills_association.options[:through]).to eq(:role_skills)
  end

  it "requires a title" do
    role = described_class.new

    expect(role).not_to be_valid
    expect(role.errors[:title]).to include("can't be blank")
  end
end
