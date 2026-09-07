class MakeSkillsNameCategoryIndexCaseInsensitive < ActiveRecord::Migration[8.1]
  def up
    remove_index :skills, column: [:name, :category] if index_exists?(:skills, [:name, :category])

    add_index :skills, "LOWER(name), category", unique: true, name: "index_skills_on_lower_name_and_category"
  end

  def down
    remove_index :skills, name: "index_skills_on_lower_name_and_category"
    add_index :skills, [:name, :category], unique: true
  end
end
