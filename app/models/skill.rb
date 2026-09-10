class Skill < ApplicationRecord
  has_many :role_skills, dependent: :restrict_with_exception
  has_many :roles, through: :role_skills
  has_many :engineering_labs, dependent: :restrict_with_exception
  has_many :proof_of_works, through: :engineering_labs
  has_many :training_items, dependent: :restrict_with_exception
  has_many :user_skills, dependent: :restrict_with_exception
  has_many :users, through: :user_skills

  validates :name, :category, presence: true
  validates :name, uniqueness: { scope: :category, case_sensitive: false }
end
