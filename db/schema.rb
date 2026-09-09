# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_09_190000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "career_profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "current_role"
    t.string "goals"
    t.string "target_market"
    t.string "target_role"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "years_of_experience"
    t.index ["user_id"], name: "index_career_profiles_on_user_id", unique: true
  end

  create_table "engineering_labs", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.text "deliverables", default: [], null: false, array: true
    t.text "description", null: false
    t.text "objective", null: false
    t.bigint "skill_id", null: false
    t.datetime "started_at"
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.bigint "training_item_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["skill_id"], name: "index_engineering_labs_on_skill_id"
    t.index ["training_item_id"], name: "index_engineering_labs_on_training_item_id", unique: true, where: "(training_item_id IS NOT NULL)"
    t.index ["user_id", "status"], name: "index_engineering_labs_on_user_id_and_status"
    t.index ["user_id"], name: "index_engineering_labs_on_user_id"
  end

  create_table "role_skills", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "importance"
    t.integer "required_level", null: false
    t.bigint "role_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id", "skill_id"], name: "index_role_skills_on_role_id_and_skill_id", unique: true
    t.index ["role_id"], name: "index_role_skills_on_role_id"
    t.index ["skill_id"], name: "index_role_skills_on_skill_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "company"
    t.datetime "created_at", null: false
    t.string "description"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index "lower((name)::text), category", name: "index_skills_on_lower_name_and_category", unique: true
  end

  create_table "training_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.integer "position", null: false
    t.bigint "skill_id", null: false
    t.integer "status", default: 0, null: false
    t.string "title", null: false
    t.bigint "training_plan_id", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_training_items_on_skill_id"
    t.index ["training_plan_id", "position"], name: "index_training_items_on_training_plan_id_and_position", unique: true
    t.index ["training_plan_id"], name: "index_training_items_on_training_plan_id"
  end

  create_table "training_plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_training_plans_on_user_id", unique: true
  end

  create_table "user_skills", force: :cascade do |t|
    t.integer "confidence"
    t.datetime "created_at", null: false
    t.integer "level"
    t.bigint "skill_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["skill_id"], name: "index_user_skills_on_skill_id"
    t.index ["user_id", "skill_id"], name: "index_user_skills_on_user_id_and_skill_id", unique: true
    t.index ["user_id"], name: "index_user_skills_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "career_profiles", "users"
  add_foreign_key "engineering_labs", "skills"
  add_foreign_key "engineering_labs", "training_items", on_delete: :nullify
  add_foreign_key "engineering_labs", "users"
  add_foreign_key "role_skills", "roles"
  add_foreign_key "role_skills", "skills"
  add_foreign_key "training_items", "skills"
  add_foreign_key "training_items", "training_plans"
  add_foreign_key "training_plans", "users"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
end
