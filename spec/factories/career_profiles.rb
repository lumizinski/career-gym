FactoryBot.define do
  factory :career_profile do
    association :user
    current_role { "Senior Backend Engineer" }
    years_of_experience { 8 }
    target_role { "Staff Backend Engineer" }
    target_market { "International Remote" }
    goals { "Lead architecture decisions and mentor engineers." }
  end
end
