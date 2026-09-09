FactoryBot.define do
  factory :role do
    company { "Career Gym Benchmark" }
    sequence(:title) { |n| "Role #{n}" }
    description { "Representative target role requirements." }
  end
end
