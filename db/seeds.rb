skills_by_category = {
  "Backend" => [ "Ruby", "Rails", "API Design", "Background Jobs" ],
  "Database" => [ "PostgreSQL", "Advanced SQL", "Database Indexing", "Query Optimization" ],
  "Architecture" => [ "System Design", "Distributed Systems", "Caching", "Messaging" ],
  "Cloud" => [ "AWS", "Docker", "CI/CD" ],
  "Observability" => [ "Metrics", "Logging", "Distributed Tracing", "Observability" ]
}

skills_by_category.each do |category, names|
  names.each do |name|
    Skill.find_or_create_by!(name: name, category: category)
  end
end

staff_backend_engineer = Role.find_or_initialize_by(title: "Staff Backend Engineer")
staff_backend_engineer.company = "Career Gym Benchmark"
staff_backend_engineer.description = "Representative target role requirements for staff-level backend engineers."
staff_backend_engineer.save!

requirements = [
  [ "Ruby", "Backend", 7, "Medium" ],
  [ "Rails", "Backend", 7, "Medium" ],
  [ "PostgreSQL", "Database", 7, "High" ],
  [ "System Design", "Architecture", 8, "Critical" ],
  [ "Distributed Systems", "Architecture", 7, "Critical" ],
  [ "Caching", "Architecture", 7, "High" ],
  [ "Messaging", "Architecture", 7, "High" ],
  [ "AWS", "Cloud", 7, "Medium" ],
  [ "Docker", "Cloud", 7, "Medium" ],
  [ "Observability", "Observability", 7, "High" ]
]

requirements.each do |name, category, required_level, importance|
  skill = Skill.find_or_create_by!(name: name, category: category)
  role_skill = staff_backend_engineer.role_skills.find_or_initialize_by(skill: skill)
  role_skill.required_level = required_level
  role_skill.importance = importance
  role_skill.save!
end

demo_user = User.find_or_initialize_by(email: "demo@careergym.local")
demo_user.password = "password123!" if demo_user.new_record?
demo_user.password_confirmation = "password123!" if demo_user.new_record?
demo_user.save!

demo_profile = demo_user.career_profile || demo_user.build_career_profile
demo_profile.assign_attributes(
  current_role: "Senior Backend Engineer",
  years_of_experience: 8,
  target_role: "Staff Backend Engineer",
  target_market: "International Remote",
  goals: "Build stronger proof of work for backend leadership roles."
)
demo_profile.save!

labs = [
  {
    skill_name: "PostgreSQL",
    category: "Database",
    current_level: 5,
    training_item_title: "Run a PostgreSQL query optimization experiment",
    training_item_description: "Investigate the performance impact of indexes and query structure with EXPLAIN ANALYZE.",
    title: "PostgreSQL Query Optimization Experiment",
    description: "Practical database tuning workout focused on indexes and query plans.",
    objective: "Investigate the performance impact of indexes and query structure using EXPLAIN ANALYZE.",
    deliverables: [ "Baseline query plan", "Index comparison notes", "EXPLAIN ANALYZE results", "Optimization summary" ],
    status: :completed
  },
  {
    skill_name: "Rails",
    category: "Backend",
    current_level: 6,
    training_item_title: "Run a Rails N+1 query investigation",
    training_item_description: "Measure and eliminate N+1 queries in a Rails application.",
    title: "Rails N+1 Query Investigation",
    description: "Practical Rails performance workout focused on query efficiency.",
    objective: "Measure and eliminate N+1 queries in a Rails application.",
    deliverables: [ "Reproduction steps", "Captured query traces", "Refactoring notes", "Before and after comparison" ],
    status: :in_progress
  },
  {
    skill_name: "System Design",
    category: "Architecture",
    current_level: 2,
    training_item_title: "Design a scalable notification service",
    training_item_description: "Design a notification system capable of processing large volumes of asynchronous notifications.",
    title: "Design a Scalable Notification Service",
    description: "System design workout for asynchronous notifications at scale.",
    objective: "Design an asynchronous notification system with retries, idempotency, and failure handling.",
    deliverables: [ "Architecture diagram", "API design", "Data model", "Failure scenarios", "Scalability analysis" ],
    status: :in_progress
  },
  {
    skill_name: "Distributed Systems",
    category: "Architecture",
    current_level: 3,
    training_item_title: "Implement an idempotent background job processing workflow",
    training_item_description: "Design and implement a job-processing workflow that safely handles retries.",
    title: "Idempotent Background Job Processing",
    description: "Distributed systems workout focused on safe retries.",
    objective: "Design and implement a job-processing workflow that safely handles retries.",
    deliverables: [ "Retry flow design", "Idempotency strategy", "Failure handling notes", "Operational checklist" ],
    status: :pending
  },
  {
    skill_name: "Observability",
    category: "Observability",
    current_level: 4,
    training_item_title: "Instrument a Rails application",
    training_item_description: "Add useful metrics, logs, and traces and identify a simulated performance problem.",
    title: "Instrument a Rails Application",
    description: "Observability workout focused on metrics, logs, and traces.",
    objective: "Add useful metrics, logs, and traces and identify a simulated performance problem.",
    deliverables: [ "Instrumentation plan", "Metrics list", "Trace or log examples", "Performance findings" ],
    status: :pending
  }
]

training_plan = TrainingPlan.find_or_create_by!(user: demo_user)

labs.each_with_index do |lab, index|
  skill = Skill.find_or_create_by!(name: lab[:skill_name], category: lab[:category])

  user_skill = UserSkill.find_or_initialize_by(user: demo_user, skill: skill)
  user_skill.level = lab[:current_level]
  user_skill.confidence = [ lab[:current_level] + 2, 10 ].min
  user_skill.save!

  training_item = training_plan.training_items.find_or_initialize_by(title: lab[:training_item_title])
  training_item.skill = skill
  training_item.description = lab[:training_item_description]
  training_item.status = :pending
  training_item.position = index + 1
  training_item.save!

  engineering_lab = demo_user.engineering_labs.find_or_initialize_by(title: lab[:title])
  engineering_lab.skill = skill
  engineering_lab.training_item = training_item
  engineering_lab.description = lab[:description]
  engineering_lab.objective = lab[:objective]
  engineering_lab.deliverables = lab[:deliverables]
  engineering_lab.status = lab[:status]
  engineering_lab.save!
end
