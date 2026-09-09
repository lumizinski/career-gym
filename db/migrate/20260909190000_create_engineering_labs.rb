class CreateEngineeringLabs < ActiveRecord::Migration[8.1]
  def change
    create_table :engineering_labs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      t.references :training_item, null: true, index: false, foreign_key: { on_delete: :nullify }
      t.string :title, null: false
      t.text :description, null: false
      t.text :objective, null: false
      t.integer :status, null: false, default: 0
      t.text :deliverables, array: true, null: false, default: []
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end

    add_index :engineering_labs, [ :user_id, :status ]
    add_index :engineering_labs, :training_item_id, unique: true, where: "training_item_id IS NOT NULL"
  end
end
