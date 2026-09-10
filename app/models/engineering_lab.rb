class EngineeringLab < ApplicationRecord
  enum :status, { pending: 0, in_progress: 1, completed: 2 }

  belongs_to :user
  belongs_to :skill
  belongs_to :training_item, optional: true
  has_many :proof_of_works, dependent: :destroy

  scope :ordered, lambda {
    order(
      Arel.sql("CASE engineering_labs.status WHEN 1 THEN 0 WHEN 0 THEN 1 ELSE 2 END"),
      started_at: :desc,
      created_at: :desc,
      id: :desc
    )
  }

  validates :title, :description, :objective, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :training_item_id, uniqueness: true, allow_nil: true
  validate :training_item_context_matches

  before_validation :apply_status_timestamps

  def deliverables_text
    deliverables.join("\n")
  end

  def deliverables_text=(value)
    self.deliverables = value.to_s.lines.map(&:strip).reject(&:blank?)
  end

  private

  def apply_status_timestamps
    self.started_at ||= Time.current if in_progress? || completed?
    self.completed_at ||= Time.current if completed?
    self.completed_at = nil unless completed?
  end

  def training_item_context_matches
    return if training_item.blank?

    if training_item.training_plan.user_id != user_id
      errors.add(:training_item, "must belong to the same user")
    end

    if training_item.skill_id != skill_id
      errors.add(:skill, "must match the training item skill")
    end
  end
end
