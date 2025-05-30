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

ActiveRecord::Schema[7.0].define(version: 2025_05_29_213805) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.text "code"
    t.json "code_lines"
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

  create_table "code_flow_elements", force: :cascade do |t|
    t.string "title"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comprehension_questions", force: :cascade do |t|
    t.bigint "leetcode_problem_id", null: false
    t.text "question"
    t.text "answer"
    t.string "question_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leetcode_problem_id"], name: "index_comprehension_questions_on_leetcode_problem_id"
  end

  create_table "infrastructure_pattern_dependencies", force: :cascade do |t|
    t.bigint "infrastructure_pattern_id", null: false
    t.string "dependable_type", null: false
    t.bigint "dependable_id", null: false
    t.text "usage", null: false
    t.integer "position"
    t.boolean "visibility", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dependable_type", "dependable_id"], name: "index_infrastructure_pattern_dependencies_on_dependable"
    t.index ["infrastructure_pattern_id", "dependable_type", "dependable_id"], name: "idx_ipd_on_ip_and_dependable"
    t.index ["infrastructure_pattern_id", "dependable_type", "dependable_id"], name: "idx_ipd_uniqueness", unique: true
    t.index ["infrastructure_pattern_id"], name: "idx_ipd_on_ip_id"
    t.index ["position"], name: "index_infrastructure_pattern_dependencies_on_position"
  end

  create_table "infrastructure_patterns", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "position"
    t.boolean "visibility", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position", "visibility"], name: "idx_ip_on_position_and_visibility"
    t.index ["position"], name: "index_infrastructure_patterns_on_position"
    t.index ["title"], name: "index_infrastructure_patterns_on_title"
  end

  create_table "job_statuses", force: :cascade do |t|
    t.string "job_type", null: false
    t.string "status", null: false
    t.datetime "started_at", null: false
    t.datetime "completed_at"
    t.text "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_type"], name: "index_job_statuses_on_job_type"
    t.index ["started_at"], name: "index_job_statuses_on_started_at"
    t.index ["status"], name: "index_job_statuses_on_status"
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

  create_table "leetcode_problems", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "difficulty"
    t.string "url"
    t.string "topics"
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

  create_table "project_requirement_tools", force: :cascade do |t|
    t.bigint "project_requirement_id", null: false
    t.string "toolable_type", null: false
    t.bigint "toolable_id", null: false
    t.boolean "appropriate", default: true
    t.text "reason"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "suggested_name"
    t.index ["position"], name: "index_project_requirement_tools_on_position"
    t.index ["project_requirement_id"], name: "index_project_requirement_tools_on_project_requirement_id"
    t.index ["toolable_type", "toolable_id"], name: "idx_proj_req_tools_on_toolable"
    t.index ["toolable_type", "toolable_id"], name: "index_project_requirement_tools_on_toolable"
  end

  create_table "project_requirements", force: :cascade do |t|
    t.bigint "wonder_id", null: false
    t.string "title", null: false
    t.integer "position"
    t.string "scale"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_project_requirements_on_position"
    t.index ["wonder_id"], name: "index_project_requirements_on_wonder_id"
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

  create_table "quest_step_choices", force: :cascade do |t|
    t.bigint "quest_step_id", null: false
    t.text "body"
    t.boolean "status", default: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "reasoning"
    t.index ["quest_step_id"], name: "index_quest_step_choices_on_quest_step_id"
  end

  create_table "quest_steps", force: :cascade do |t|
    t.string "image_url"
    t.string "thumbnail_url"
    t.bigint "quest_id", null: false
    t.integer "position"
    t.text "body"
    t.integer "success_step_id"
    t.integer "failure_step_id"
    t.integer "quest_reward_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quest_id"], name: "index_quest_steps_on_quest_id"
  end

  create_table "quests", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "position"
    t.string "image_url"
    t.integer "difficulty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "questable_type"
    t.bigint "questable_id"
    t.index ["questable_type", "questable_id"], name: "index_quests_on_questable_type_and_questable_id"
  end

  create_table "quiz_choices", force: :cascade do |t|
    t.bigint "quiz_id", null: false
    t.integer "position"
    t.boolean "correct", default: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "reasoning"
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

  create_table "scripts", force: :cascade do |t|
    t.string "title", null: false
    t.text "body"
    t.string "scriptable_type", null: false
    t.integer "scriptable_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "linkedin_body"
    t.text "tiktok_body"
    t.text "youtube_body"
    t.string "youtube_title"
    t.index ["position"], name: "index_scripts_on_position"
    t.index ["scriptable_type", "scriptable_id"], name: "index_scripts_on_scriptable_type_and_scriptable_id"
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

  create_table "trade_off_aspect_contenders", force: :cascade do |t|
    t.integer "trade_off_contender_id"
    t.integer "trade_off_aspect_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trade_off_aspects", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "position"
    t.integer "trade_off_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trade_off_contenders", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.integer "trade_off_id"
    t.text "description"
    t.integer "skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trade_offs", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.boolean "header"
    t.integer "trade_off_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "wonder_infrastructure_patterns", force: :cascade do |t|
    t.bigint "wonder_id", null: false
    t.bigint "infrastructure_pattern_id", null: false
    t.integer "position"
    t.boolean "visibility", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["infrastructure_pattern_id", "wonder_id"], name: "idx_wip_on_ip_and_wonder"
    t.index ["infrastructure_pattern_id"], name: "idx_wip_on_ip_id"
    t.index ["position"], name: "index_wonder_infrastructure_patterns_on_position"
    t.index ["wonder_id", "infrastructure_pattern_id"], name: "idx_wip_uniqueness", unique: true
    t.index ["wonder_id"], name: "index_wonder_infrastructure_patterns_on_wonder_id"
  end

  create_table "wonders", force: :cascade do |t|
    t.string "title"
    t.string "image"
    t.text "description"
    t.integer "difficulty"
    t.integer "position"
    t.bigint "wonder_id"
    t.boolean "visibility"
    t.string "code"
    t.string "slug"
    t.boolean "is_course"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wonder_id"], name: "index_wonders_on_wonder_id"
  end

  add_foreign_key "chapters", "chapters"
  add_foreign_key "comprehension_questions", "leetcode_problems"
  add_foreign_key "infrastructure_pattern_dependencies", "infrastructure_patterns"
  add_foreign_key "project_requirement_tools", "project_requirements"
  add_foreign_key "project_requirements", "wonders"
  add_foreign_key "quest_step_choices", "quest_steps"
  add_foreign_key "quest_steps", "quests"
  add_foreign_key "quiz_choices", "quizzes"
  add_foreign_key "skills", "skills"
  add_foreign_key "wonder_infrastructure_patterns", "infrastructure_patterns"
  add_foreign_key "wonder_infrastructure_patterns", "wonders"
  add_foreign_key "wonders", "wonders"
end
