require "rails_helper"

RSpec.describe TrainingPlan, type: :model do
  it "belongs to user" do
    association = described_class.reflect_on_association(:user)

    expect(association.macro).to eq(:belongs_to)
  end

  it "has many training items" do
    association = described_class.reflect_on_association(:training_items)

    expect(association.macro).to eq(:has_many)
  end

  it "validates one plan per user" do
    user = create(:user)
    create(:training_plan, user: user)

    duplicate = build(:training_plan, user: user)

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:user_id]).to include("has already been taken")
  end
end
