class TrainingPlan < ApplicationRecord
  belongs_to :user
  has_many :training_items, -> { order(:position, :id) }, dependent: :destroy

  validates :user_id, uniqueness: true
end
