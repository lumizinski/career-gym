class TrainingController < ApplicationController
  before_action :authenticate_user!

  def index
    @analysis = SkillGapAnalysis.new(current_user)
    @training_plan = current_user.training_plan
    @training_items_by_skill = grouped_training_items
  end

  def create
    training_plan = TrainingPlanGenerator.new(current_user).generate

    if training_plan.present?
      redirect_to training_index_path, notice: "Training plan was successfully created."
    else
      redirect_to training_index_path, alert: "No skill gaps found. Update your target role or skill assessments."
    end
  end

  private

  def grouped_training_items
    return [] unless @training_plan

    gap_index = @analysis.prioritized_gaps.each_with_index.each_with_object({}) do |(gap, index), memo|
      memo[gap.skill.id] = [ index, gap ]
    end

    @training_plan.training_items.includes(:skill, :engineering_lab).group_by(&:skill).map do |skill, items|
      priority_index, gap = gap_index.fetch(skill.id, [ Float::INFINITY, nil ])
      {
        skill: skill,
        gap: gap,
        items: items.sort_by(&:position),
        priority_index: priority_index
      }
    end.sort_by { |group| group[:priority_index] }
  end
end
