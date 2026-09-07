class CreateCareerProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :career_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :current_role
      t.string :years_of_experience
      t.string :target_role
      t.string :target_market
      t.string :goals

      t.timestamps
    end
  end
end
