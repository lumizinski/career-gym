require "rails_helper"

RSpec.describe EngineeringLab, type: :model do
  it "belongs to user, skill, and optionally training item" do
    user_association = described_class.reflect_on_association(:user)
    skill_association = described_class.reflect_on_association(:skill)
    training_item_association = described_class.reflect_on_association(:training_item)

    expect(user_association.macro).to eq(:belongs_to)
    expect(skill_association.macro).to eq(:belongs_to)
    expect(training_item_association.macro).to eq(:belongs_to)
    expect(training_item_association.options[:optional]).to be(true)
  end

  it "requires title, description, and objective" do
    lab = build(:engineering_lab, title: nil, description: nil, objective: nil)

    expect(lab).not_to be_valid
    expect(lab.errors[:title]).to be_present
    expect(lab.errors[:description]).to be_present
    expect(lab.errors[:objective]).to be_present
  end

  it "defaults to pending status" do
    lab = create(:engineering_lab)

    expect(lab).to be_pending
  end

  it "supports in_progress and completed statuses" do
    lab = create(:engineering_lab)

    lab.in_progress!
    expect(lab).to be_in_progress

    lab.completed!
    expect(lab).to be_completed
  end

  it "sets started_at when moving into progress" do
    lab = create(:engineering_lab, started_at: nil)

    travel_to Time.zone.parse("2026-09-09 12:00:00 UTC") do
      lab.update!(status: :in_progress)

      expect(lab.started_at).to eq(Time.zone.parse("2026-09-09 12:00:00 UTC"))
      expect(lab.completed_at).to be_nil
    end
  end

  it "sets completed_at when completed" do
    lab = create(:engineering_lab, status: :in_progress)

    travel_to Time.zone.parse("2026-09-09 13:00:00 UTC") do
      lab.update!(status: :completed)

      expect(lab.completed_at).to eq(Time.zone.parse("2026-09-09 13:00:00 UTC"))
      expect(lab.started_at).to be_present
    end
  end

  it "requires ownership and skill alignment with the training item" do
    owner = create(:user)
    other_user = create(:user)
    skill = create(:skill, name: "PostgreSQL", category: "Database")
    other_skill = create(:skill, name: "Rails", category: "Backend")
    training_item = create(:training_item, training_plan: create(:training_plan, user: owner), skill: skill)

    wrong_user_lab = build(:engineering_lab, user: other_user, skill: skill, training_item: training_item)
    wrong_skill_lab = build(:engineering_lab, user: owner, skill: other_skill, training_item: training_item)

    expect(wrong_user_lab).not_to be_valid
    expect(wrong_user_lab.errors[:training_item]).to include("must belong to the same user")
    expect(wrong_skill_lab).not_to be_valid
    expect(wrong_skill_lab.errors[:skill]).to include("must match the training item skill")
  end
end
