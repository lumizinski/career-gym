class UserSkill < ApplicationRecord
  SKILL_GAP_LEVEL = 7

  belongs_to :user
  belongs_to :skill

  scope :dashboard_order, -> { includes(:skill).joins(:skill).order("skills.category ASC, user_skills.level DESC, skills.name ASC") }

  validates :level, :confidence, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 10
  }
  validates :skill_id, uniqueness: { scope: :user_id }
end
