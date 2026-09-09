class RenameJobsToRolesAndJobSkillsToRoleSkills < ActiveRecord::Migration[8.1]
  def change
    rename_table :jobs, :roles
    rename_table :job_skills, :role_skills
    rename_column :role_skills, :job_id, :role_id
  end
end
