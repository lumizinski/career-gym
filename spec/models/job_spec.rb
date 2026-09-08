require "rails_helper"

RSpec.describe Job, type: :model do
  it "has job skills and skills associations" do
    job_skills_association = described_class.reflect_on_association(:job_skills)
    skills_association = described_class.reflect_on_association(:skills)

    expect(job_skills_association.macro).to eq(:has_many)
    expect(skills_association.macro).to eq(:has_many)
    expect(skills_association.options[:through]).to eq(:job_skills)
  end

  it "requires a title" do
    job = described_class.new

    expect(job).not_to be_valid
    expect(job.errors[:title]).to include("can't be blank")
  end
end
