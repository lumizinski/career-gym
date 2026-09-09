class TrainingPlanGenerator
  MAX_SKILLS = 3

  TEMPLATE_TITLES_BY_SKILL = {
    "System Design" => [
      "Study scalability fundamentals",
      "Study CAP and consistency",
      "Design a URL shortener",
      "Design a notification system",
      "Document the design"
    ],
    "PostgreSQL" => [
      "Study query planning",
      "Practice EXPLAIN ANALYZE",
      "Study database indexes",
      "Run a query optimization experiment",
      "Document the results"
    ],
    "Distributed Systems" => [
      "Study distributed system fundamentals",
      "Study messaging and queues",
      "Study idempotency",
      "Design an asynchronous processing system",
      "Implement a background-processing experiment"
    ]
  }.freeze

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def generate
    prioritized_gaps = SkillGapAnalysis.new(user).prioritized_gaps.first(MAX_SKILLS)
    return nil if prioritized_gaps.empty?

    ApplicationRecord.transaction do
      user.training_plan&.destroy!

      training_plan = user.create_training_plan!
      position = 1

      prioritized_gaps.each do |gap|
        template_titles_for(gap.skill.name).each do |title|
          training_plan.training_items.create!(
            skill: gap.skill,
            title: title,
            description: default_description(gap.skill.name, title),
            status: :pending,
            position: position
          )
          position += 1
        end
      end

      training_plan
    end
  end

  private

  def template_titles_for(skill_name)
    TEMPLATE_TITLES_BY_SKILL.fetch(skill_name) { generic_template_titles(skill_name) }
  end

  def generic_template_titles(skill_name)
    [
      "Review #{skill_name} fundamentals",
      "Practice #{skill_name} with a focused exercise",
      "Document what you learned about #{skill_name}"
    ]
  end

  def default_description(skill_name, title)
    "Skill focus: #{skill_name}. Activity: #{title}."
  end
end
