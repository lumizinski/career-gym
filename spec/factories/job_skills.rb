FactoryBot.define do
  factory :job_skill do
    association :job
    association :skill
    required_level { 7 }
    importance { "High" }
  end
end
