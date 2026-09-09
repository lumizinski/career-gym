class TrainingItem < ApplicationRecord
  enum :status, { pending: 0, in_progress: 1, completed: 2 }

  belongs_to :training_plan
  belongs_to :skill

  scope :ordered, -> { order(:position, :id) }

  validates :title, :description, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :position, uniqueness: { scope: :training_plan_id }
end
