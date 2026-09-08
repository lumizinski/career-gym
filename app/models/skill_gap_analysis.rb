class SkillGapAnalysis
  SkillGap = Data.define(:skill, :current_level, :required_level, :gap, :importance) do
    def gap?
      current_level < required_level
    end

    def strength?
      !gap?
    end

    def critical_gap?
      gap? && importance == "Critical"
    end
  end

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def target_role
    user.career_profile&.target_role
  end

  def required_skills?
    target_job.present? && target_job.job_skills.exists?
  end

  def biggest_gap
    ordered_gaps.first
  end

  def critical_gaps
    ordered_gaps.select(&:critical_gap?)
  end

  def other_gaps
    ordered_gaps.reject(&:critical_gap?)
  end

  def strengths
    skill_gaps.select(&:strength?).sort_by do |skill_gap|
      [ JobSkill.importance_rank(skill_gap.importance), skill_gap.skill.name ]
    end
  end

  private

  def ordered_gaps
    skill_gaps.select(&:gap?).sort_by do |skill_gap|
      [ -skill_gap.gap, JobSkill.importance_rank(skill_gap.importance), skill_gap.skill.name ]
    end
  end

  def skill_gaps
    @skill_gaps ||= target_job_skills.map do |job_skill|
      current_level = user_skill_levels.fetch(job_skill.skill_id, 0)
      required_level = job_skill.required_level

      SkillGap.new(
        skill: job_skill.skill,
        current_level: current_level,
        required_level: required_level,
        gap: [ required_level - current_level, 0 ].max,
        importance: job_skill.importance
      )
    end
  end

  def user_skill_levels
    @user_skill_levels ||= user.user_skills.each_with_object({}) do |user_skill, levels|
      levels[user_skill.skill_id] = user_skill.level
    end
  end

  def target_job
    @target_job ||= begin
      role = target_role
      if role.blank?
        nil
      else
        Job.includes(job_skills: :skill).find_by(title: role)
      end
    end
  end

  def target_job_skills
    return [] unless target_job

    target_job.job_skills.includes(:skill).to_a
  end
end
