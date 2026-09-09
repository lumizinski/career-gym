require "rails_helper"

RSpec.describe TrainingItem, type: :model do
  it "belongs to training plan and skill" do
    plan_association = described_class.reflect_on_association(:training_plan)
    skill_association = described_class.reflect_on_association(:skill)

    expect(plan_association.macro).to eq(:belongs_to)
    expect(skill_association.macro).to eq(:belongs_to)
  end

  it "requires title, description, and positive position" do
    training_item = build(:training_item, title: nil, description: nil, position: 0)

    expect(training_item).not_to be_valid
    expect(training_item.errors[:title]).to be_present
    expect(training_item.errors[:description]).to be_present
    expect(training_item.errors[:position]).to be_present
  end

  it "defaults to pending status" do
    training_item = create(:training_item)

    expect(training_item).to be_pending
  end

  it "supports in_progress and completed statuses" do
    training_item = create(:training_item)

    training_item.in_progress!
    expect(training_item).to be_in_progress

    training_item.completed!
    expect(training_item).to be_completed
  end

  it "orders by position then id" do
    plan = create(:training_plan)
    skill = create(:skill)
    later = create(:training_item, training_plan: plan, skill: skill, position: 2)
    earlier = create(:training_item, training_plan: plan, skill: create(:skill), position: 1)

    expect(described_class.where(id: [ later.id, earlier.id ]).ordered).to eq([ earlier, later ])
  end
end
