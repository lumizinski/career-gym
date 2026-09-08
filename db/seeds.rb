skills_by_category = {
  "Backend" => ["Ruby", "Rails", "API Design", "Background Jobs"],
  "Database" => ["PostgreSQL", "Advanced SQL", "Database Indexing", "Query Optimization"],
  "Architecture" => ["System Design", "Distributed Systems", "Caching", "Messaging"],
  "Cloud" => ["AWS", "Docker", "CI/CD"],
  "Observability" => ["Metrics", "Logging", "Distributed Tracing"]
}

skills_by_category.each do |category, names|
  names.each do |name|
    Skill.find_or_create_by!(name: name, category: category)
  end
end
