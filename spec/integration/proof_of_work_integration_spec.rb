require "rails_helper"

RSpec.describe "Proof of work integration" do
  it "connects a user, engineering lab, and proof of work" do
    user = create(:user)
    skill = create(:skill, name: "PostgreSQL", category: "Database")
    lab = create(:engineering_lab, user: user, skill: skill, status: :completed)
    proof = create(:proof_of_work, user: user, engineering_lab: lab, proof_type: :benchmark)

    expect(proof.user).to eq(user)
    expect(proof.engineering_lab).to eq(lab)
    expect(proof.engineering_lab.user).to eq(user)
  end

  it "groups proof of work by skill through the engineering lab relationship" do
    user = create(:user)
    skill = create(:skill, name: "Rails", category: "Backend")
    lab = create(:engineering_lab, user: user, skill: skill, status: :completed, title: "Rails N+1 Investigation")
    proof = create(:proof_of_work, user: user, engineering_lab: lab, proof_type: :github_repository)

    grouped = user.proof_of_works.includes(engineering_lab: :skill).group_by(&:skill)

    expect(grouped.keys).to contain_exactly(skill)
    expect(grouped.fetch(skill)).to contain_exactly(proof)
    expect(proof.skill).to eq(skill)
  end
end
