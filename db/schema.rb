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

ActiveRecord::Schema[7.2].define(version: 2024_10_23_203100) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"

  create_table "analysis_item_steps", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "analysis_item_id", null: false
    t.uuid "analysis_step_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["analysis_item_id"], name: "index_analysis_item_steps_on_analysis_item_id"
    t.index ["analysis_step_id"], name: "index_analysis_item_steps_on_analysis_step_id"
  end

  create_table "analysis_items", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name"
    t.string "cpf"
    t.integer "status", default: 0
    t.integer "error_status", default: 0
    t.integer "prediction"
    t.integer "payment_situation", default: 0
    t.integer "disapproval_situation"
    t.uuid "clone_of_id"
    t.uuid "analysis_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["analysis_report_id"], name: "index_analysis_items_on_analysis_report_id"
    t.index ["clone_of_id"], name: "index_analysis_items_on_clone_of_id"
  end

  create_table "analysis_reports", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "cpfs"
    t.integer "status"
    t.float "fee"
    t.boolean "approved"
    t.integer "disapproval_situation"
    t.uuid "api_client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_client_id"], name: "index_analysis_reports_on_api_client_id"
  end

  create_table "analysis_steps", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name"
    t.integer "command_class"
    t.integer "index_order"
    t.boolean "enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_clients", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "client_id", null: false
    t.string "client_secret", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "analysis_item_steps", "analysis_items"
  add_foreign_key "analysis_item_steps", "analysis_steps"
  add_foreign_key "analysis_items", "analysis_items", column: "clone_of_id"
  add_foreign_key "analysis_items", "analysis_reports"
  add_foreign_key "analysis_reports", "api_clients"
end
