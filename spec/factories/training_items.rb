FactoryBot.define do
  factory :training_item do
    association :training_plan
    association :skill
    sequence(:title) { |n| "Training item #{n}" }
    description { "Focused training activity." }
    status { :pending }
    sequence(:position) { |n| n }
  end
end
