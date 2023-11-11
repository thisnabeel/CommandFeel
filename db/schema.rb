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

ActiveRecord::Schema[7.0].define(version: 2023_11_10_061334) do
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

  create_table "algorithms", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "expected"
    t.integer "difficulty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 1
    t.integer "algorithm_id"
    t.boolean "self_explanatory"
    t.json "input_params", default: []
    t.json "test_cases", default: []
    t.text "challenge_body", default: ""
    t.boolean "header", default: false
  end

  create_table "attempts", force: :cascade do |t|
    t.integer "algorithm_id"
    t.integer "programming_language_id"
    t.integer "user_id"
    t.text "error_message"
    t.boolean "passing"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "console_output", default: ""
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
    t.boolean "codeable", default: false
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

  create_table "language_algorithm_starters", force: :cascade do |t|
    t.integer "programming_language_id"
    t.integer "algorithm_id"
    t.text "code"
    t.json "code_lines"
    t.string "video_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "programming_language_traits", force: :cascade do |t|
    t.integer "programming_language_id"
    t.integer "trait_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "programming_languages", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.string "editor_slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_skills", force: :cascade do |t|
    t.integer "skill_id"
    t.integer "project_id"
    t.integer "position"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.integer "user_id"
    t.string "title"
    t.text "description"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proof_links", force: :cascade do |t|
    t.integer "proof_id"
    t.string "url"
    t.string "title"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proofs", force: :cascade do |t|
    t.integer "user_id"
    t.integer "challenge_id"
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "proofable_id"
    t.string "proofable_type"
  end

  create_table "quiz_choices", force: :cascade do |t|
    t.bigint "quiz_id", null: false
    t.integer "position"
    t.boolean "correct", default: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_quiz_choices_on_quiz_id"
  end

  create_table "quiz_sets", force: :cascade do |t|
    t.integer "quiz_setable_id"
    t.string "quiz_setable_type"
    t.integer "position"
    t.string "title"
    t.text "description"
    t.boolean "pop_quizable"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "quizable_type"
    t.integer "quizable_id"
    t.boolean "jeopardy", default: true
    t.text "question"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quiz_set_id"
  end

  create_table "saved_jobs", force: :cascade do |t|
    t.string "title"
    t.string "company"
    t.integer "position"
    t.string "jd_link"
    t.text "jd"
    t.string "stage"
    t.text "skills"
    t.integer "user_id"
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

  create_table "test_cases", force: :cascade do |t|
    t.integer "language_algorithm_starter_id"
    t.text "code"
    t.text "expectation"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "algorithm_id"
  end

  create_table "traits", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 1
  end

  create_table "user_quiz_statuses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "quiz_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "username", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.json "tokens"
    t.string "authentication_token", limit: 30
    t.string "avatar_source_url"
    t.string "avatar_cropped_url"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "chapters", "chapters"
  add_foreign_key "quiz_choices", "quizzes"
  add_foreign_key "skills", "skills"
end
