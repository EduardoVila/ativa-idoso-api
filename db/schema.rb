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

ActiveRecord::Schema[8.0].define(version: 2026_07_21_193000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"

  create_table "answers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "option_id", null: false
    t.string "complement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_answers_on_option_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "options", force: :cascade do |t|
    t.string "description", null: false
    t.string "color", null: false
    t.string "icon", null: false
    t.text "other_options", default: [], array: true
    t.bigint "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "description", null: false
    t.bigint "research_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["research_id"], name: "index_questions_on_research_id"
  end

  create_table "researches", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "satisfaction_survey_responses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "qr_code_access_score", null: false
    t.integer "videos_understanding_score", null: false
    t.integer "videos_motivation_score", null: false
    t.datetime "submitted_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "platform_access_score", default: 3, null: false
    t.index ["user_id"], name: "index_satisfaction_survey_responses_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "cpf", null: false
    t.integer "status", default: 0, null: false
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_users_on_cpf", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.string "title", null: false
    t.string "url", null: false
    t.integer "section", null: false
    t.integer "level", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "views", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "video_id", null: false
    t.boolean "watched_completely", default: false
    t.integer "percentage_watched", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_views_on_user_id"
    t.index ["video_id"], name: "index_views_on_video_id"
  end

  add_foreign_key "answers", "options"
  add_foreign_key "answers", "users"
  add_foreign_key "options", "questions"
  add_foreign_key "questions", "researches"
  add_foreign_key "satisfaction_survey_responses", "users"
  add_foreign_key "views", "users"
  add_foreign_key "views", "videos"
end
