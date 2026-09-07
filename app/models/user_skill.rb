class UserSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  validates :level, :confidence, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 10
  }
  validates :skill_id, uniqueness: { scope: :user_id }
end
