class UserSkillsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_skill, only: %i[edit update]
  before_action :set_available_skills, only: %i[create edit update]

  def create
    @user_skill = current_user.user_skills.build(user_skill_params)

    if @user_skill.save
      redirect_to career_dashboard_path, notice: "Skill assessment was successfully added."
    else
      analysis = SkillGapAnalysis.new(current_user)
      @career_profile = current_user.career_profile
      @user_skills = ordered_user_skills.to_a
      @skills_by_category = @user_skills.group_by { |skill| skill.skill.category }
      @skill_gaps = @user_skills.select { |user_skill| user_skill.level < UserSkill::SKILL_GAP_LEVEL }
        .sort_by { |user_skill| [ user_skill.level, user_skill.skill.name ] }
      @skills_count = @user_skills.size
      @average_skill_level = @skills_count.positive? ? (@user_skills.sum(&:level).to_f / @skills_count).round(1) : nil
      @analysis = analysis
      @training_plan = current_user.training_plan
      @training_item_counts = if @training_plan
        {
          completed: @training_plan.training_items.completed.count,
          in_progress: @training_plan.training_items.in_progress.count,
          pending: @training_plan.training_items.pending.count
        }
      else
        { completed: 0, in_progress: 0, pending: 0 }
      end
      training_skill_ids = @training_plan ? @training_plan.training_items.reorder(nil).distinct.pluck(:skill_id) : []
      @highest_priority_training_gap = analysis.prioritized_gaps.find { |gap| training_skill_ids.include?(gap.skill.id) }
      labs = current_user.engineering_labs
      @engineering_lab_counts = {
        completed: labs.completed.count,
        in_progress: labs.in_progress.count,
        pending: labs.pending.count
      }
      @latest_engineering_lab = labs.includes(:skill).order(updated_at: :desc, id: :desc).first
      @proof_of_work_count = current_user.proof_of_works.count
      @proof_of_work_type_counts = current_user.proof_of_works.group(:proof_type).count
      render "career_dashboards/show", status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @user_skill.update(user_skill_params)
      redirect_to career_dashboard_path, notice: "Skill assessment was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_user_skill
    @user_skill = current_user.user_skills.includes(:skill).find(params.expect(:id))
  end

  def set_available_skills
    taken_skill_ids = current_user.user_skills.where.not(id: @user_skill&.id).select(:skill_id)
    available_skills = Skill.where.not(id: taken_skill_ids)
    available_skills = available_skills.or(Skill.where(id: @user_skill.skill_id)) if @user_skill&.skill_id

    @available_skills = available_skills.order(:category, :name)
  end

  def ordered_user_skills
    current_user.user_skills.dashboard_order
  end

  def user_skill_params
    params.expect(user_skill: [ :skill_id, :level, :confidence ])
  end
end
