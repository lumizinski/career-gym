FactoryBot.define do
  factory :user_skill do
    association :user
    association :skill
    level { 6 }
    confidence { 6 }
  end
end
