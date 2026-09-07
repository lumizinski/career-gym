FactoryBot.define do
  factory :skill do
    sequence(:name) { |n| "Skill #{n}" }
    category { "Backend" }
  end
end
