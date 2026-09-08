class Job < ApplicationRecord
  has_many :job_skills, dependent: :destroy
  has_many :skills, through: :job_skills

  validates :title, presence: true
end
