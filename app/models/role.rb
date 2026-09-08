class Role < ApplicationRecord
  has_many :role_skills, dependent: :destroy
  has_many :skills, through: :role_skills

  validates :title, presence: true
end
