class Skill < ApplicationRecord
  has_many :role_skills, dependent: :restrict_with_exception
  has_many :roles, through: :role_skills
  has_many :user_skills, dependent: :restrict_with_exception
  has_many :users, through: :user_skills

  validates :name, :category, presence: true
  validates :name, uniqueness: { scope: :category, case_sensitive: false }
end
