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

ActiveRecord::Schema[7.2].define(version: 2024_11_01_171038) do
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

  create_table "analysis_predictions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "cpf"
    t.boolean "approved"
    t.float "fee"
    t.string "label"
    t.jsonb "input_data"
    t.uuid "analysis_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["analysis_item_id"], name: "index_analysis_predictions_on_analysis_item_id"
  end

  create_table "analysis_reports", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "cpfs", array: true
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

  create_table "analysis_tokens", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "access_token"
    t.string "token_type"
    t.integer "expires_in"
    t.string "scope"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_clients", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "client_id", null: false
    t.string "client_secret", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "idwall_addresses", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "main"
    t.string "city"
    t.string "state"
    t.string "number"
    t.string "zip_code"
    t.string "street"
    t.string "neighborhood"
    t.string "people_at_address"
    t.string "kind"
    t.uuid "idwall_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idwall_report_id"], name: "index_idwall_addresses_on_idwall_report_id"
  end

  create_table "idwall_cpfs", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "gender"
    t.string "number"
    t.string "birth_date"
    t.string "source"
    t.string "name"
    t.string "income"
    t.string "income_tax_situation"
    t.string "cpf_cadastral_situation"
    t.string "cpf_subscription_date"
    t.string "cpf_verifying_digit"
    t.string "year_of_death"
    t.string "social_name"
    t.uuid "idwall_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idwall_report_id"], name: "index_idwall_cpfs_on_idwall_report_id"
  end

  create_table "idwall_related_people", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "cpf"
    t.string "name"
    t.string "kind"
    t.uuid "idwall_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idwall_report_id"], name: "index_idwall_related_people_on_idwall_report_id"
  end

  create_table "idwall_reports", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "number"
    t.integer "status"
    t.string "raw_data"
    t.uuid "analysis_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["analysis_item_id"], name: "index_idwall_reports_on_analysis_item_id"
  end

  create_table "idwall_trial_parts", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "cnpj"
    t.string "cpf"
    t.string "birth_date"
    t.string "name"
    t.string "rg"
    t.string "gender"
    t.string "kind"
    t.string "title"
    t.uuid "idwall_trial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idwall_trial_id"], name: "index_idwall_trial_parts_on_idwall_trial_id"
  end

  create_table "idwall_trials", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "subject"
    t.string "kind"
    t.uuid "idwall_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idwall_report_id"], name: "index_idwall_trials_on_idwall_report_id"
  end

  add_foreign_key "analysis_item_steps", "analysis_items"
  add_foreign_key "analysis_item_steps", "analysis_steps"
  add_foreign_key "analysis_items", "analysis_items", column: "clone_of_id"
  add_foreign_key "analysis_items", "analysis_reports"
  add_foreign_key "analysis_predictions", "analysis_items"
  add_foreign_key "analysis_reports", "api_clients"
  add_foreign_key "idwall_addresses", "idwall_reports"
  add_foreign_key "idwall_cpfs", "idwall_reports"
  add_foreign_key "idwall_related_people", "idwall_reports"
  add_foreign_key "idwall_reports", "analysis_items"
  add_foreign_key "idwall_trial_parts", "idwall_trials"
  add_foreign_key "idwall_trials", "idwall_reports"
end
