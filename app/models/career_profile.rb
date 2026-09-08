class CareerProfile < ApplicationRecord
  belongs_to :user

  validates :current_role, :target_role, :target_market, :goals, presence: true
  validates :years_of_experience, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :user_id, uniqueness: true
end
