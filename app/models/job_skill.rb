class JobSkill < ApplicationRecord
  IMPORTANCE_ORDER = {
    "Critical" => 0,
    "High" => 1,
    "Medium" => 2,
    "Low" => 3
  }.freeze

  belongs_to :job
  belongs_to :skill

  validates :importance, presence: true, inclusion: { in: IMPORTANCE_ORDER.keys }
  validates :required_level, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 10
  }
  validates :skill_id, uniqueness: { scope: :job_id }

  def self.importance_rank(importance)
    IMPORTANCE_ORDER.fetch(importance, IMPORTANCE_ORDER.length)
  end
end
