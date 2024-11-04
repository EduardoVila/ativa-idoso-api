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

ActiveRecord::Schema[7.2].define(version: 2024_11_01_200015) do
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

  create_table "boa_vista_addresses", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "street_type"
    t.string "street"
    t.string "number"
    t.string "neighborhood"
    t.string "city"
    t.string "federal_unit"
    t.string "zip_code"
    t.string "complement"
    t.string "address_type"
    t.uuid "boa_vista_cadastral_location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_location_id"], name: "index_boa_vista_addresses_on_boa_vista_cadastral_location_id"
  end

  create_table "boa_vista_basic_registrations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "cpf"
    t.string "name"
    t.string "mother_name"
    t.string "birth_date"
    t.string "exposed_person"
    t.string "cpf_situation"
    t.uuid "boa_vista_cadastral_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_id"], name: "index_boa_vista_basic_registrations_on_boa_vista_cadastral_id"
  end

  create_table "boa_vista_cadastral_locations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "cpf"
    t.string "emails"
    t.uuid "boa_vista_cadastral_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_id"], name: "index_boa_vista_cadastral_locations_on_boa_vista_cadastral_id"
  end

  create_table "boa_vista_cadastral_qualifications", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "cpf"
    t.string "death"
    t.uuid "boa_vista_cadastral_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_id"], name: "idx_on_boa_vista_cadastral_id_353e336e1f"
  end

  create_table "boa_vista_cadastrals", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "raw_data"
    t.string "consumer_type", null: false
    t.uuid "consumer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consumer_type", "consumer_id"], name: "index_boa_vista_cadastrals_on_consumer"
  end

  create_table "boa_vista_phones", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "ddd"
    t.string "number"
    t.string "phone_type"
    t.uuid "boa_vista_cadastral_location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_location_id"], name: "index_boa_vista_phones_on_boa_vista_cadastral_location_id"
  end

  create_table "boa_vista_related_people", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name"
    t.string "degree_of_kinship"
    t.string "cpf"
    t.uuid "boa_vista_cadastral_qualification_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_qualification_id"], name: "idx_on_boa_vista_cadastral_qualification_id_f3e4c504f2"
  end

  add_foreign_key "analysis_item_steps", "analysis_items"
  add_foreign_key "analysis_item_steps", "analysis_steps"
  add_foreign_key "analysis_items", "analysis_items", column: "clone_of_id"
  add_foreign_key "analysis_items", "analysis_reports"
  add_foreign_key "analysis_predictions", "analysis_items"
  add_foreign_key "analysis_reports", "api_clients"
  add_foreign_key "boa_vista_addresses", "boa_vista_cadastral_locations"
  add_foreign_key "boa_vista_basic_registrations", "boa_vista_cadastrals"
  add_foreign_key "boa_vista_cadastral_locations", "boa_vista_cadastrals"
  add_foreign_key "boa_vista_cadastral_qualifications", "boa_vista_cadastrals"
  add_foreign_key "boa_vista_phones", "boa_vista_cadastral_locations"
  add_foreign_key "boa_vista_related_people", "boa_vista_cadastral_qualifications"
end
