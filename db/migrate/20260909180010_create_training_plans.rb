class CreateTrainingPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :training_plans do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
