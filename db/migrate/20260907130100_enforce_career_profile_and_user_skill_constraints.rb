class EnforceCareerProfileAndUserSkillConstraints < ActiveRecord::Migration[8.1]
  def up
    change_column :career_profiles, :years_of_experience, :integer, using: "NULLIF(years_of_experience, '')::integer"

    change_column :user_skills, :level, :integer, using: "NULLIF(level, '')::integer"
    change_column :user_skills, :confidence, :integer, using: "NULLIF(confidence, '')::integer"

    remove_index :career_profiles, :user_id if index_exists?(:career_profiles, :user_id)
    add_index :career_profiles, :user_id, unique: true unless index_exists?(:career_profiles, :user_id, unique: true)

    remove_index :user_skills, column: [:user_id, :skill_id] if index_exists?(:user_skills, [:user_id, :skill_id], unique: false)
    add_index :user_skills, [:user_id, :skill_id], unique: true unless index_exists?(:user_skills, [:user_id, :skill_id], unique: true)
  end

  def down
    remove_index :user_skills, column: [:user_id, :skill_id] if index_exists?(:user_skills, [:user_id, :skill_id], unique: true)
    remove_index :career_profiles, :user_id if index_exists?(:career_profiles, :user_id)
    add_index :career_profiles, :user_id unless index_exists?(:career_profiles, :user_id)

    change_column :user_skills, :confidence, :string
    change_column :user_skills, :level, :string
    change_column :career_profiles, :years_of_experience, :string
  end
end
