require "rails_helper"

RSpec.describe "Engineering lab creation from training item" do
  it "associates the training item, lab, skill, and user" do
    user = create(:user)
    skill = create(:skill, name: "Distributed Systems", category: "Architecture")
    plan = create(:training_plan, user: user)
    item = create(:training_item, training_plan: plan, skill: skill)

    lab = EngineeringLab.create!(
      user: user,
      skill: skill,
      training_item: item,
      title: "Idempotent Background Job Processing",
      description: "Practical distributed systems workout.",
      objective: "Design a retry-safe job workflow.",
      deliverables: [ "Workflow diagram", "Failure modes" ]
    )

    expect(lab.training_item).to eq(item)
    expect(lab.skill).to eq(skill)
    expect(lab.user).to eq(user)
    expect(lab.training_item.training_plan.user).to eq(user)
  end
end
