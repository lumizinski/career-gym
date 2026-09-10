require "rails_helper"

RSpec.describe ProofOfWork, type: :model do
  it "belongs to user and engineering lab" do
    user_association = described_class.reflect_on_association(:user)
    lab_association = described_class.reflect_on_association(:engineering_lab)

    expect(user_association.macro).to eq(:belongs_to)
    expect(lab_association.macro).to eq(:belongs_to)
  end

  it "requires title and description" do
    proof = build(:proof_of_work, title: nil, description: nil)

    expect(proof).not_to be_valid
    expect(proof.errors[:title]).to be_present
    expect(proof.errors[:description]).to be_present
  end

  it "accepts the supported proof types" do
    described_class.proof_types.each_key do |proof_type|
      proof = build(:proof_of_work, proof_type: proof_type)

      expect(proof).to be_valid
    end
  end

  it "rejects unsupported proof types" do
    proof = build(:proof_of_work, proof_type: "podcast")

    expect(proof).not_to be_valid
    expect(proof.errors[:proof_type]).to be_present
  end

  it "allows a blank url" do
    proof = build(:proof_of_work, url: nil)

    expect(proof).to be_valid
  end

  it "rejects non-http urls" do
    proof = build(:proof_of_work, url: "ftp://example.com/evidence")

    expect(proof).not_to be_valid
    expect(proof.errors[:url]).to include("must be a valid HTTP or HTTPS URL")
  end

  it "rejects malformed urls" do
    proof = build(:proof_of_work, url: "not a url")

    expect(proof).not_to be_valid
    expect(proof.errors[:url]).to include("must be a valid HTTP or HTTPS URL")
  end

  it "requires the proof owner to match the engineering lab owner" do
    owner = create(:user)
    intruder = create(:user)
    lab = create(:engineering_lab, user: owner, status: :completed)
    proof = build(:proof_of_work, user: intruder, engineering_lab: lab)

    expect(proof).not_to be_valid
    expect(proof.errors[:engineering_lab]).to include("must belong to the same user")
  end

  it "requires a completed engineering lab" do
    lab = create(:engineering_lab, status: :in_progress, completed_at: nil)
    proof = build(:proof_of_work, user: lab.user, engineering_lab: lab)

    expect(proof).not_to be_valid
    expect(proof.errors[:engineering_lab]).to include("must be completed before adding proof of work")
  end

  it "copies completed_at from the engineering lab when created" do
    completed_at = Time.zone.parse("2026-09-10 12:00:00 UTC")
    lab = create(:engineering_lab, status: :completed, completed_at: completed_at)
    proof = create(:proof_of_work, user: lab.user, engineering_lab: lab, completed_at: nil)

    expect(proof.completed_at).to eq(completed_at)
  end
end
