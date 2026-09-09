FactoryBot.define do
  factory :engineering_lab do
    association :user
    association :skill
    title { "Engineering Lab" }
    description { "Turn training into practical work." }
    objective { "Produce a concrete deliverable that strengthens the target skill." }
    status { :pending }
    deliverables { [ "Experiment notes", "Summary of findings" ] }
  end
end
