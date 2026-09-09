FactoryBot.define do
  factory :role_skill do
    association :role
    association :skill
    required_level { 7 }
    importance { "High" }
  end
end
