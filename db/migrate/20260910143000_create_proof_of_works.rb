class CreateProofOfWorks < ActiveRecord::Migration[8.1]
  def change
    create_table :proof_of_works do |t|
      t.references :user, null: false, foreign_key: true
      t.references :engineering_lab, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description, null: false
      t.string :proof_type, null: false
      t.string :url
      t.datetime :completed_at, null: false

      t.timestamps
    end

    add_index :proof_of_works, [ :user_id, :completed_at ]
    add_index :proof_of_works, [ :engineering_lab_id, :proof_type ]
  end
end
