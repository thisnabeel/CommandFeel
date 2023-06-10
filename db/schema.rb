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

ActiveRecord::Schema[7.0].define(version: 2023_06_09_184230) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "timescaledb"

  create_table "abstractions", force: :cascade do |t|
    t.integer "abstractable_id"
    t.string "abstractable_type"
    t.text "article"
    t.integer "last_edited_by"
    t.string "preview"
    t.integer "position"
    t.string "source_url"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "challenges", force: :cascade do |t|
    t.integer "challengeable_id"
    t.string "challengeable_type"
    t.string "preview"
    t.integer "position"
    t.string "source_url"
    t.text "body"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chapters", force: :cascade do |t|
    t.bigint "chapter_id"
    t.string "title"
    t.text "description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_chapters_on_chapter_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "quizable_type"
    t.integer "quizable_id"
    t.boolean "jeopardy", default: true
    t.text "question"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skills", force: :cascade do |t|
    t.string "title"
    t.string "image"
    t.text "description"
    t.integer "difficulty"
    t.integer "position"
    t.bigint "skill_id"
    t.boolean "visibility"
    t.string "code"
    t.string "slug"
    t.boolean "is_course"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_skills_on_skill_id"
  end

  add_foreign_key "chapters", "chapters"
  add_foreign_key "skills", "skills"
end
