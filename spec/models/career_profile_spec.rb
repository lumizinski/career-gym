require "rails_helper"

RSpec.describe CareerProfile, type: :model do
  it "belongs to user" do
    association = described_class.reflect_on_association(:user)

    expect(association.macro).to eq(:belongs_to)
  end

  it "is invalid without required attributes" do
    profile = described_class.new

    expect(profile).not_to be_valid
    expect(profile.errors[:current_role]).to include("can't be blank")
    expect(profile.errors[:target_role]).to include("can't be blank")
    expect(profile.errors[:target_market]).to include("can't be blank")
    expect(profile.errors[:goals]).to include("can't be blank")
    expect(profile.errors[:years_of_experience]).to include("can't be blank")
  end

  it "validates years_of_experience as non-negative integer" do
    profile = build(:career_profile, years_of_experience: -1)

    expect(profile).not_to be_valid
    expect(profile.errors[:years_of_experience]).to be_present
  end

  it "enforces one profile per user" do
    user = create(:user)
    create(:career_profile, user: user)

    duplicate = build(:career_profile, user: user)

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:user_id]).to include("has already been taken")
  end
end
