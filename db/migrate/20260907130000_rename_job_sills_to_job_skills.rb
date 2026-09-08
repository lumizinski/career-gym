class RenameJobSillsToJobSkills < ActiveRecord::Migration[8.1]
  def change
    rename_table :job_sills, :job_skills
  end
end
