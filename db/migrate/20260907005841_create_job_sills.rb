class CreateJobSills < ActiveRecord::Migration[8.1]
  def change
    create_table :job_sills do |t|
      t.string :job
      t.string :skill
      t.string :importance

      t.timestamps
    end
  end
end
