FactoryBot.define do
  factory :proof_of_work do
    association :user
    association :engineering_lab, factory: :engineering_lab, user: instance.user, status: :completed
    title { engineering_lab.title }
    description { "Evidence captured from completed engineering work." }
    proof_type { :benchmark }
    url { "https://example.com/evidence" }
    completed_at { engineering_lab.completed_at || Time.current }
  end
end
