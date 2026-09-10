FactoryBot.define do
  factory :proof_of_work do
    user
    engineering_lab { association :engineering_lab, user: user, status: :completed }
    title { engineering_lab.title }
    description { "Evidence captured from completed engineering work." }
    proof_type { :benchmark }
    url { "https://example.com/evidence" }
    completed_at { engineering_lab.completed_at || Time.current }
  end
end
