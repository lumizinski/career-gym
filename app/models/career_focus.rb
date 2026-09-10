class CareerFocus
  MAX_PRIORITY_SKILLS = 3

  IMPORTANCE_BONUS = {
    "Critical" => 25,
    "High" => 18,
    "Medium" => 10,
    "Low" => 4
  }.freeze

  PrioritySkill = Data.define(
    :skill,
    :current_level,
    :target_level,
    :gap,
    :importance,
    :confidence,
    :priority_score,
    :priority_label,
    :reason
  )

  attr_reader :user

  def initialize(user, date: Date.current)
    @user = user
    @date = date
    @analysis = SkillGapAnalysis.new(user)
  end

  def target_role
    @analysis.target_role
  end

  def required_skills?
    @analysis.required_skills?
  end

  def target_role_record
    @target_role_record ||= begin
      role_title = target_role
      role_title.present? ? Role.find_by(title: role_title) : nil
    end
  end

  def skills
    @skills ||= prioritized_skills.first(MAX_PRIORITY_SKILLS)
  end

  def top_skill
    skills.first
  end

  def week_range_label
    week_start = @date.beginning_of_week(:monday)
    week_end = week_start + 6.days

    if week_start.month == week_end.month
      "#{week_start.strftime('%B %-d')}–#{week_end.strftime('%-d')}"
    else
      "#{week_start.strftime('%B %-d')}–#{week_end.strftime('%B %-d')}"
    end
  end

  def training_items_for(priority_skill)
    training_items(priority_skill).reject(&:completed?)
  end

  def pending_training_items_count_for(priority_skill)
    training_items_for(priority_skill).count
  end

  def progress_for(priority_skill)
    items = training_items(priority_skill)
    labs_completed = labs_completed_counts.fetch(priority_skill.skill.id, 0)
    proof_count = proof_counts.fetch(priority_skill.skill.id, 0)

    {
      training_items_count: items.count,
      training_items_completed_count: items.count(&:completed?),
      labs_completed_count: labs_completed,
      proof_of_work_count: proof_count
    }
  end

  private

  def prioritized_skills
    @analysis.prioritized_gaps.map do |gap|
      confidence = user_skill_confidence.fetch(gap.skill.id, 0)
      score = priority_score_for(gap:, confidence:)

      PrioritySkill.new(
        skill: gap.skill,
        current_level: gap.current_level,
        target_level: gap.required_level,
        gap: gap.gap,
        importance: gap.importance,
        confidence: confidence,
        priority_score: score,
        priority_label: priority_label_for(score),
        reason: reason_for(gap:, confidence:)
      )
    end.sort_by { |skill| [ -skill.priority_score, skill.skill.name ] }
  end

  def priority_score_for(gap:, confidence:)
    (gap.gap * 10) + IMPORTANCE_BONUS.fetch(gap.importance, 0) + (10 - confidence.to_i)
  end

  def priority_label_for(score)
    return "VERY HIGH" if score >= 90
    return "HIGH" if score >= 70
    return "MEDIUM" if score >= 45

    "LOW"
  end

  def reason_for(gap:, confidence:)
    if gap.gap >= 5 && gap.importance == "Critical"
      "Largest skill gap and critical for your target role."
    elsif gap.gap >= 5
      "Large skill gap for your target role."
    elsif confidence.to_i <= 4
      "Low confidence indicates this skill needs focused practice."
    else
      "Important gap to close for your target role."
    end
  end

  def training_items(priority_skill)
    training_items_by_skill.fetch(priority_skill.skill.id, [])
  end

  def training_items_by_skill
    @training_items_by_skill ||= begin
      items = user.training_plan&.training_items&.includes(:skill)&.ordered&.to_a || []
      items.group_by(&:skill_id)
    end
  end

  def labs_completed_counts
    @labs_completed_counts ||= user.engineering_labs.completed.group(:skill_id).count
  end

  def proof_counts
    @proof_counts ||= user.proof_of_works.joins(:engineering_lab).group("engineering_labs.skill_id").count
  end

  def user_skill_confidence
    @user_skill_confidence ||= user.user_skills.each_with_object({}) do |user_skill, memo|
      memo[user_skill.skill_id] = user_skill.confidence
    end
  end
end
