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

staff_backend_engineer = Job.find_or_initialize_by(title: "Staff Backend Engineer")
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
  job_skill = staff_backend_engineer.job_skills.find_or_initialize_by(skill: skill)
  job_skill.required_level = required_level
  job_skill.importance = importance
  job_skill.save!
end
