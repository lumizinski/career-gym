class CareerDashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @analysis = SkillGapAnalysis.new(current_user)
    @career_profile = current_user.career_profile
    @user_skills = current_user.user_skills.dashboard_order.to_a
    @skills_by_category = @user_skills.group_by { |user_skill| user_skill.skill.category }
    @skill_gaps = @user_skills.select { |user_skill| user_skill.level < UserSkill::SKILL_GAP_LEVEL }
      .sort_by { |user_skill| [ user_skill.level, user_skill.skill.name ] }
    @skills_count = @user_skills.size
    @average_skill_level = @skills_count.positive? ? (@user_skills.sum(&:level).to_f / @skills_count).round(1) : nil
    @training_plan = current_user.training_plan
    @training_item_counts = training_item_counts
    @highest_priority_training_gap = highest_priority_training_gap
    @engineering_lab_counts = engineering_lab_counts
    @latest_engineering_lab = current_user.engineering_labs.includes(:skill).order(updated_at: :desc, id: :desc).first

    @user_skill = current_user.user_skills.build
    @available_skills = Skill.where.not(id: current_user.user_skills.select(:skill_id)).order(:category, :name)
  end

  private

  def training_item_counts
    return { completed: 0, in_progress: 0, pending: 0 } unless @training_plan

    items = @training_plan.training_items
    {
      completed: items.completed.count,
      in_progress: items.in_progress.count,
      pending: items.pending.count
    }
  end

  def highest_priority_training_gap
    return nil unless @training_plan

    training_skill_ids = @training_plan.training_items.reorder(nil).distinct.pluck(:skill_id)
    @analysis.prioritized_gaps.find { |gap| training_skill_ids.include?(gap.skill.id) }
  end

  def engineering_lab_counts
    labs = current_user.engineering_labs
    {
      completed: labs.completed.count,
      in_progress: labs.in_progress.count,
      pending: labs.pending.count
    }
  end
end
