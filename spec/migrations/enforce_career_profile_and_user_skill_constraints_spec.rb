require "rails_helper"
require Rails.root.join("db/migrate/20260907130100_enforce_career_profile_and_user_skill_constraints")

RSpec.describe EnforceCareerProfileAndUserSkillConstraints, type: :model do
  describe "#sanitize_numeric_strings" do
    it "normalizes non-numeric legacy string values before casting" do
      migration = described_class.new

      expect(migration).to receive(:execute).with(include("UPDATE career_profiles").and(include("years_of_experience"))).ordered
      expect(migration).to receive(:execute).with(include("UPDATE user_skills").and(include("SET level"))).ordered
      expect(migration).to receive(:execute).with(include("UPDATE user_skills").and(include("SET confidence"))).ordered

      migration.send(:sanitize_numeric_strings)
    end
  end
end
