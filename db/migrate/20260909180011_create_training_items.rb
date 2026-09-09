class CreateTrainingItems < ActiveRecord::Migration[8.1]
  def change
    create_table :training_items do |t|
      t.references :training_plan, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description, null: false
      t.integer :status, null: false, default: 0
      t.integer :position, null: false

      t.timestamps
    end

    add_index :training_items, [ :training_plan_id, :position ], unique: true
  end
end
