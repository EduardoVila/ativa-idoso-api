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

ActiveRecord::Schema[8.0].define(version: 2024_12_17_163855) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"

  create_table "analysis_item_steps", force: :cascade do |t|
    t.uuid "analysis_item_id", null: false
    t.bigint "analysis_step_id", null: false
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
    t.jsonb "features", default: {}
    t.uuid "clone_of_id"
    t.uuid "analysis_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["analysis_report_id"], name: "index_analysis_items_on_analysis_report_id"
    t.index ["clone_of_id"], name: "index_analysis_items_on_clone_of_id"
  end

  create_table "analysis_predictions", force: :cascade do |t|
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
    t.string "payload"
    t.uuid "api_client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_client_id"], name: "index_analysis_reports_on_api_client_id"
  end

  create_table "analysis_steps", force: :cascade do |t|
    t.string "name"
    t.string "command_class"
    t.integer "index_order"
    t.boolean "enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "analysis_tokens", force: :cascade do |t|
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
    t.text "validators", default: ["blocked_negativity_validator", "exceeded_debits_validator", "protested_titles_validator", "provenir_has_obit_indication_validator", "provenir_family_holding_validator", "provenir_process_validator", "provenir_age_and_income_validator"], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_webhook_events", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "callback_url"
    t.string "event_type"
    t.string "event_id"
    t.string "job_id"
    t.integer "status"
    t.jsonb "payload"
    t.jsonb "response"
    t.uuid "api_client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_client_id"], name: "index_api_webhook_events_on_api_client_id"
  end

  create_table "boa_vista_acerta_essencials", force: :cascade do |t|
    t.string "cpf", null: false
    t.integer "credit_type", default: 0, null: false
    t.string "raw_data"
    t.string "consumer_type"
    t.uuid "consumer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consumer_type", "consumer_id"], name: "index_boa_vista_acerta_essencials_on_consumer"
  end

  create_table "boa_vista_additional_informations", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "text"
    t.string "origin"
    t.string "fu_origin"
    t.string "information_type"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_additional_information_on_acerta_essencial_id"
  end

  create_table "boa_vista_addresses", force: :cascade do |t|
    t.string "street_type"
    t.string "street"
    t.string "number"
    t.string "neighborhood"
    t.string "city"
    t.string "federal_unit"
    t.string "zip_code"
    t.string "complement"
    t.string "address_type"
    t.bigint "boa_vista_cadastral_location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_location_id"], name: "index_boa_vista_addresses_on_boa_vista_cadastral_location_id"
  end

  create_table "boa_vista_bank_branch_phones_addresses", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "bank"
    t.string "bank_name"
    t.string "agency"
    t.string "agency_name"
    t.string "address"
    t.string "neighborhood"
    t.string "zip_code"
    t.string "city"
    t.string "federative_unit"
    t.string "plaza"
    t.string "area_code"
    t.string "phone_1"
    t.string "phone_2"
    t.string "reserved"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "idx_on_boa_vista_acerta_essencial_id_79c1bf7475"
  end

  create_table "boa_vista_basic_registrations", force: :cascade do |t|
    t.string "cpf"
    t.string "name"
    t.string "mother_name"
    t.string "birth_date"
    t.string "exposed_person"
    t.string "cpf_situation"
    t.bigint "boa_vista_cadastral_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_id"], name: "index_boa_vista_basic_registrations_on_boa_vista_cadastral_id"
  end

  create_table "boa_vista_cadastral_locations", force: :cascade do |t|
    t.string "cpf", null: false
    t.string "emails", array: true
    t.bigint "boa_vista_cadastral_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_id"], name: "index_boa_vista_cadastral_locations_on_boa_vista_cadastral_id"
  end

  create_table "boa_vista_cadastral_qualifications", force: :cascade do |t|
    t.string "cpf", null: false
    t.string "death"
    t.bigint "boa_vista_cadastral_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_id"], name: "idx_on_boa_vista_cadastral_id_353e336e1f"
  end

  create_table "boa_vista_cadastrals", force: :cascade do |t|
    t.string "raw_data"
    t.string "consumer_type"
    t.uuid "consumer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consumer_type", "consumer_id"], name: "index_boa_vista_cadastrals_on_consumer"
  end

  create_table "boa_vista_cheque_additional_informations", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "document_type"
    t.string "document_number"
    t.string "text"
    t.string "type_of_register"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_cheque_additional_info_on_acerta_essencial_id"
  end

  create_table "boa_vista_cheque_stoppeds", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "occurrence_type"
    t.string "document_type"
    t.string "document_number"
    t.string "bank"
    t.string "agency"
    t.string "current_account"
    t.string "cheque"
    t.string "point"
    t.string "occurrence_date"
    t.string "availability_date"
    t.string "informant"
    t.string "indicator"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_cheque_stopped_on_acerta_essencial_id"
  end

  create_table "boa_vista_cheques_stopped_for_reason21s", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "document_type"
    t.string "document_number"
    t.string "bank"
    t.string "agency"
    t.string "current_account"
    t.string "initial_cheque"
    t.string "final_cheque"
    t.string "point"
    t.string "occurrence_date"
    t.string "availability_date"
    t.string "currency"
    t.string "value"
    t.string "informant"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_cheques_stopped_for_reason21_on_acerta_essencial_id"
  end

  create_table "boa_vista_current_account_historics", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "bank"
    t.string "agency"
    t.string "current_account"
    t.string "document_type"
    t.string "document_number"
    t.string "consultation_date"
    t.string "consultation_hour"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_current_account_historic_on_acerta_essencial_id"
  end

  create_table "boa_vista_debit_occurrences", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "total_debtor"
    t.string "total_guarantor"
    t.string "accumulated_value"
    t.string "first_debit_date"
    t.string "first_debit_value"
    t.string "biggest_debit_date"
    t.string "biggest_debit_value"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_debit_occurrences_on_acerta_essencial_id"
  end

  create_table "boa_vista_debits", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "occurrence_type"
    t.string "occurrence_date"
    t.string "contract"
    t.string "availability_date"
    t.string "currency", default: "0"
    t.string "value"
    t.string "condition"
    t.string "informant"
    t.string "segment"
    t.string "informed_by_querent"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_debits_on_boa_vista_acerta_essencial_id"
  end

  create_table "boa_vista_decisions", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "document_type"
    t.string "document"
    t.string "score"
    t.string "approves"
    t.string "text"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_decisions_on_boa_vista_acerta_essencial_id"
  end

  create_table "boa_vista_documents_names", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "name"
    t.string "birth_date"
    t.string "document_type"
    t.string "document_number"
    t.string "document_2"
    t.string "document_3"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_documents_names_on_acerta_essencial_id"
  end

  create_table "boa_vista_historic_informed_cheques", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "document_type"
    t.string "document_number"
    t.string "bank"
    t.string "agency"
    t.string "current_account"
    t.string "cheque"
    t.string "consultation_date"
    t.string "consultation_hour"
    t.string "network"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_historic_informed_cheque_on_acerta_essencial_id"
  end

  create_table "boa_vista_identifications", force: :cascade do |t|
    t.string "register_size"
    t.string "register"
    t.string "document"
    t.string "name"
    t.string "mother_name"
    t.string "birth_date"
    t.string "rg_number"
    t.string "emitting_organ"
    t.string "rg_federative_unit"
    t.string "rg_emitting_date"
    t.string "consulted_gender"
    t.string "birth_city"
    t.string "marital_status"
    t.string "dependent_number"
    t.string "educational_level"
    t.string "revenue_situation"
    t.string "update_date"
    t.string "cpf_zone"
    t.string "voter_title"
    t.string "death"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_identifications_on_acerta_essencial_id"
  end

  create_table "boa_vista_list_of_returns_reported_by_ccfs", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "document_type"
    t.string "document_number"
    t.string "name"
    t.string "bank"
    t.string "agency"
    t.string "reason_12"
    t.string "last_occurrence_12_date"
    t.string "reason_13"
    t.string "last_occurrence_13_date"
    t.string "reason_14"
    t.string "last_occurrence_14_date"
    t.string "reason_99"
    t.string "last_occurrence_99_date"
    t.string "bank_name"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_list_of_returns_reported_by_ccfs_on_acerta_essencial_id"
  end

  create_table "boa_vista_locations", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "public_place_type"
    t.string "public_place_name"
    t.string "public_place_number"
    t.string "complement"
    t.string "neighborhood"
    t.string "city"
    t.string "federative_unit"
    t.string "zip_code"
    t.string "ddd_1"
    t.string "phone_1"
    t.string "ddd_2"
    t.string "phone_2"
    t.string "ddd_3"
    t.string "phone_3"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_locations_on_boa_vista_acerta_essencial_id"
  end

  create_table "boa_vista_phone_confirmations", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "area_code"
    t.string "phone"
    t.string "document_type"
    t.string "document_number"
    t.string "name"
    t.string "neighborhood"
    t.string "zip_code"
    t.string "city"
    t.string "federative_unit"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_phone_confirmations_on_acerta_essencial_id"
  end

  create_table "boa_vista_phones", force: :cascade do |t|
    t.string "ddd"
    t.string "number"
    t.string "phone_type"
    t.bigint "boa_vista_cadastral_location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_location_id"], name: "index_boa_vista_phones_on_boa_vista_cadastral_location_id"
  end

  create_table "boa_vista_previous90_days_consultations", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "total"
    t.string "year_1"
    t.string "month_1"
    t.string "total_1"
    t.string "year_2"
    t.string "month_2"
    t.string "total_2"
    t.string "year_3"
    t.string "month_3"
    t.string "total_3"
    t.string "year_4"
    t.string "month_4"
    t.string "total_4"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_previous90_days_consultations_on_acerta_essencial_id"
  end

  create_table "boa_vista_previous_cheque_consultations", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "document_type"
    t.string "document_number"
    t.string "consultation_type"
    t.string "credit_date"
    t.string "credit_hour"
    t.string "currency"
    t.string "value"
    t.string "informant"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_previous_cheque_consultations_on_acerta_essencial_id"
  end

  create_table "boa_vista_previous_queries", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "occurrence_type"
    t.string "date"
    t.string "currency"
    t.string "value"
    t.string "informant"
    t.string "product"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_previous_queries_on_acerta_essencial_id"
  end

  create_table "boa_vista_protested_title_summaries", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "total"
    t.string "initial_period"
    t.string "final_period"
    t.string "currency"
    t.string "accumulated_value"
    t.string "federative_unit"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "idx_on_boa_vista_acerta_essencial_id_f338e63983"
  end

  create_table "boa_vista_protested_titles", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "occurrence_type"
    t.string "registry"
    t.string "occurrence_date"
    t.string "currency"
    t.string "value"
    t.string "city"
    t.string "federative_unit"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_protested_titles_on_acerta_essencial_id"
  end

  create_table "boa_vista_record_messages", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "record_reference"
    t.string "text"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_record_messages_on_acerta_essencial_id"
  end

  create_table "boa_vista_related_people", force: :cascade do |t|
    t.string "name"
    t.string "degree_of_kinship"
    t.string "cpf"
    t.bigint "boa_vista_cadastral_qualification_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_qualification_id"], name: "idx_on_boa_vista_cadastral_qualification_id_f3e4c504f2"
  end

  create_table "boa_vista_returns_reported_by_users", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "document_type"
    t.string "document"
    t.string "bank"
    t.string "agency"
    t.string "current_account"
    t.string "initial_cheque"
    t.string "final_cheque"
    t.string "reason"
    t.string "point"
    t.string "occurrence_date"
    t.string "register_date"
    t.string "currency"
    t.string "value"
    t.string "informant_code"
    t.string "informant"
    t.string "city"
    t.string "federative_unit"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_returns_reported_by_users_on_acerta_essencial_id"
  end

  create_table "boa_vista_score_rating_several_models", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "score_type"
    t.string "score"
    t.string "plan_name"
    t.string "score_model"
    t.string "score_name"
    t.string "numeric_classification"
    t.string "alphabetic_classification"
    t.string "probability"
    t.string "text"
    t.string "code_kind_model"
    t.string "kind_description"
    t.string "text_2"
    t.string "value"
    t.string "message"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_score_rating_several_models_on_acerta_essencial_id"
  end

  create_table "boa_vista_summary_devolution_reported_by_ccfs", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "document_type"
    t.string "document_number"
    t.string "name"
    t.string "names_total"
    t.string "devolution_total"
    t.string "reason_12"
    t.string "reason_13"
    t.string "reason_14"
    t.string "reason_99"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_summary_devolution_reported_by_ccf_on_acerta_essencial_id"
  end

  create_table "boa_vista_summary_of_returns_reported_by_users", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "document_type"
    t.string "document_number"
    t.string "total"
    t.string "first_devolution_date"
    t.string "last_devolution_date"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_summary_of_return_reported_by_user_on_acerta_essencial_id"
  end

  create_table "boa_vista_summary_previous_query_cheques", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "document_type"
    t.string "document_number"
    t.string "total"
    t.string "value"
    t.string "day"
    t.string "day_value"
    t.string "pre_dated"
    t.string "pre_dated_value"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_summary_previous_query_cheques_on_acerta_essencial_id"
  end

  create_table "boa_vista_zip_code_confirmations", force: :cascade do |t|
    t.string "register_size"
    t.string "register_type"
    t.string "register"
    t.string "zip_code"
    t.string "address"
    t.string "neighborhood"
    t.string "city"
    t.string "federative_unit"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_zip_code_confirmations_on_acerta_essencial_id"
  end

  create_table "idwall_addresses", force: :cascade do |t|
    t.string "main"
    t.string "city"
    t.string "state"
    t.string "number"
    t.string "zip_code"
    t.string "street"
    t.string "neighborhood"
    t.string "people_at_address"
    t.string "kind"
    t.bigint "idwall_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idwall_report_id"], name: "index_idwall_addresses_on_idwall_report_id"
  end

  create_table "idwall_cpfs", force: :cascade do |t|
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
    t.bigint "idwall_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idwall_report_id"], name: "index_idwall_cpfs_on_idwall_report_id"
  end

  create_table "idwall_related_people", force: :cascade do |t|
    t.string "cpf"
    t.string "name"
    t.string "kind"
    t.bigint "idwall_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idwall_report_id"], name: "index_idwall_related_people_on_idwall_report_id"
  end

  create_table "idwall_reports", force: :cascade do |t|
    t.string "number", null: false
    t.integer "status", default: 0
    t.string "raw_data"
    t.uuid "analysis_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["analysis_item_id"], name: "index_idwall_reports_on_analysis_item_id"
  end

  create_table "idwall_trial_parts", force: :cascade do |t|
    t.string "cnpj"
    t.string "cpf"
    t.string "birth_date"
    t.string "name"
    t.string "rg"
    t.string "gender"
    t.string "kind"
    t.string "title"
    t.bigint "idwall_trial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idwall_trial_id"], name: "index_idwall_trial_parts_on_idwall_trial_id"
  end

  create_table "idwall_trials", force: :cascade do |t|
    t.string "subject"
    t.string "kind"
    t.bigint "idwall_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idwall_report_id"], name: "index_idwall_trials_on_idwall_report_id"
  end

  create_table "lawsuit_banned_keywords", force: :cascade do |t|
    t.string "keyword"
    t.integer "litigation_category", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pro_score_authentications", force: :cascade do |t|
    t.string "token_type"
    t.string "refresh_token"
    t.string "access_token"
    t.integer "expires_in"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pro_score_bounced_checks", force: :cascade do |t|
    t.string "numero_plugin"
    t.string "codigo_do_banco"
    t.string "nome_do_banco"
    t.string "numero_da_agencia"
    t.string "quantidade_de_ocorrencias"
    t.string "motivo_da_ocorrencia"
    t.string "data_da_ultima_ocorrencia"
    t.bigint "pro_score_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_bounced_checks_on_pro_score_report_id"
  end

  create_table "pro_score_commercial_relations", force: :cascade do |t|
    t.string "numero_plugin"
    t.string "cpfcnpj"
    t.string "razao_social"
    t.bigint "pro_score_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_commercial_relations_on_pro_score_report_id"
  end

  create_table "pro_score_criminal_antecedents", force: :cascade do |t|
    t.string "numero_plugin"
    t.string "numero_da_certidao"
    t.string "certidao"
    t.string "data_da_emissao"
    t.string "hora_da_emissao"
    t.bigint "pro_score_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_criminal_antecedents_on_pro_score_report_id"
  end

  create_table "pro_score_emergency_assistances", force: :cascade do |t|
    t.string "numero_plugin"
    t.string "mes_disponibilizado"
    t.string "codigo_do_municipio"
    t.string "municipio"
    t.string "uf"
    t.string "parcelas"
    t.string "valor"
    t.string "enquadramento"
    t.string "observacao"
    t.bigint "pro_score_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_emergency_assistances_on_pro_score_report_id"
  end

  create_table "pro_score_family_assistances", force: :cascade do |t|
    t.string "numero_plugin"
    t.string "valor"
    t.string "ultima_data_do_beneficio"
    t.string "consta_beneficio"
    t.bigint "pro_score_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_family_assistances_on_pro_score_report_id"
  end

  create_table "pro_score_family_holdings", force: :cascade do |t|
    t.string "numero_plugin"
    t.string "cpf_do_parente"
    t.string "nome_do_parente"
    t.string "grau_de_parentesco"
    t.bigint "pro_score_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_family_holdings_on_pro_score_report_id"
  end

  create_table "pro_score_monthly_benefits", force: :cascade do |t|
    t.string "numero_plugin"
    t.string "mes_competencia"
    t.string "mes_referencia"
    t.string "uf"
    t.string "nome_municipio"
    t.string "nis_beneficiario"
    t.string "numero_beneficio"
    t.string "beneficio_concedido_judicialmente"
    t.string "valor_parcela"
    t.bigint "pro_score_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_monthly_benefits_on_pro_score_report_id"
  end

  create_table "pro_score_presumed_incomes", force: :cascade do |t|
    t.string "numero_plugin"
    t.string "valor_da_renda_presumida"
    t.bigint "pro_score_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_presumed_incomes_on_pro_score_report_id"
  end

  create_table "pro_score_presumed_salary_ranges", force: :cascade do |t|
    t.string "numero_plugin"
    t.string "codigo_da_faixa_salarial"
    t.string "faixa_salarial"
    t.string "descricao_da_faixa"
    t.bigint "pro_score_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_presumed_salary_ranges_on_pro_score_report_id"
  end

  create_table "pro_score_proprable_professions", force: :cascade do |t|
    t.string "numero_plugin"
    t.string "codigo"
    t.string "titulo"
    t.bigint "pro_score_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_proprable_professions_on_pro_score_report_id"
  end

  create_table "pro_score_reports", force: :cascade do |t|
    t.string "raw_data"
    t.text "performed_searches", default: [], array: true
    t.uuid "analysis_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["analysis_item_id"], name: "index_pro_score_reports_on_analysis_item_id"
  end

  create_table "pro_score_trial_lawyers", force: :cascade do |t|
    t.string "numero_plugin"
    t.string "numero_do_processo_unico"
    t.string "advogado_nome"
    t.string "parte_nome"
    t.string "cpf"
    t.string "cnpj"
    t.string "tipo"
    t.string "oab_numero"
    t.string "oab_uf"
    t.bigint "pro_score_trial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_trial_id"], name: "index_pro_score_trial_lawyers_on_pro_score_trial_id"
  end

  create_table "pro_score_trial_motions", force: :cascade do |t|
    t.string "numero_plugin"
    t.string "numero_do_processo_unico"
    t.datetime "data"
    t.string "nome_original"
    t.bigint "pro_score_trial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_trial_id"], name: "index_pro_score_trial_motions_on_pro_score_trial_id"
  end

  create_table "pro_score_trial_parts", force: :cascade do |t|
    t.string "numero_plugin"
    t.string "numero_do_processo_unico"
    t.string "nome"
    t.string "documento"
    t.string "tipo"
    t.string "polo"
    t.bigint "pro_score_trial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_trial_id"], name: "index_pro_score_trial_parts_on_pro_score_trial_id"
  end

  create_table "pro_score_trial_topics", force: :cascade do |t|
    t.string "numero_plugin"
    t.string "numero_do_processo_unico"
    t.string "codigo_cnpj"
    t.string "titulo"
    t.bigint "pro_score_trial_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_trial_id"], name: "index_pro_score_trial_topics_on_pro_score_trial_id"
  end

  create_table "pro_score_trials", force: :cascade do |t|
    t.string "numero_plugin"
    t.string "numero_do_processo_unico"
    t.datetime "data_distribuicao"
    t.string "area"
    t.string "causa_moeda"
    t.string "causa_valor"
    t.string "unidade_origem"
    t.string "url_processo"
    t.string "sistema"
    t.datetime "data_processamento"
    t.string "tribunal"
    t.string "uf"
    t.string "segmento"
    t.string "classe_processual_nome"
    t.string "orgao_julgador"
    t.string "juiz"
    t.bigint "pro_score_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_trials_on_pro_score_report_id"
  end

  create_table "provenir_addresses", force: :cascade do |t|
    t.string "typology"
    t.string "title"
    t.string "address_main"
    t.string "number"
    t.string "complement"
    t.string "neighborhood"
    t.string "zip_code"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "address_type"
    t.string "address_currently_in_rf_site"
    t.string "complement_type"
    t.string "build_code"
    t.string "building_code"
    t.string "household_code"
    t.integer "address_entity_age"
    t.integer "address_entity_total_passages"
    t.integer "address_entity_bad_passages"
    t.integer "address_entity_crawling_passages"
    t.integer "address_entity_validation_passages"
    t.integer "address_entity_query_passages"
    t.float "address_entity_month_average_passages"
    t.integer "address_global_age"
    t.integer "address_global_total_passages"
    t.integer "address_global_bad_passages"
    t.integer "address_global_crawling_passages"
    t.integer "address_global_validation_passages"
    t.integer "address_global_query_passages"
    t.float "address_global_month_average_passages"
    t.integer "address_number_of_entities"
    t.integer "priority"
    t.boolean "is_main_for_entity"
    t.boolean "is_recent_for_entity"
    t.boolean "is_main_for_other_entity"
    t.boolean "is_recent_for_other_entity"
    t.boolean "is_active"
    t.boolean "is_ratified"
    t.boolean "is_likely_from_accountant"
    t.datetime "last_validation_date"
    t.datetime "entity_first_passage_date"
    t.datetime "entity_last_passage_date"
    t.datetime "global_first_passage_date"
    t.datetime "global_last_passage_date"
    t.integer "last3_months_passages", default: 0
    t.integer "last6_months_passages", default: 0
    t.integer "last12_months_passages", default: 0
    t.integer "last16_months_passages", default: 0
    t.integer "match_rate", default: 0
    t.datetime "creation_date"
    t.datetime "capture_date"
    t.datetime "last_update_date"
    t.boolean "has_opt_in"
    t.float "latitude"
    t.float "longitude"
    t.bigint "provenir_extended_address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_extended_address_id"], name: "index_provenir_address_extended_address_id"
  end

  create_table "provenir_aliases", force: :cascade do |t|
    t.string "common_name"
    t.string "standardized_name"
    t.bigint "provenir_basic_datum_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_basic_datum_id"], name: "index_provenir_alias_basic_datum_id"
  end

  create_table "provenir_alternative_id_numbers", force: :cascade do |t|
    t.string "document_type"
    t.string "document_number"
    t.bigint "provenir_basic_datum_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_basic_datum_id"], name: "index_provenir_alternative_id_number_basic_datum_id"
  end

  create_table "provenir_basic_data", force: :cascade do |t|
    t.string "tax_id_number"
    t.string "tax_id_country"
    t.string "name"
    t.string "gender"
    t.integer "name_word_count"
    t.integer "number_of_full_name_namesakes"
    t.integer "name_uniqueness_score"
    t.integer "first_name_uniqueness_score"
    t.integer "first_and_last_name_uniqueness_score"
    t.datetime "birth_date"
    t.integer "age"
    t.string "zodiac_sign"
    t.string "chinese_sign"
    t.string "birth_country"
    t.string "mother_name"
    t.string "father_name"
    t.string "marital_status_data"
    t.string "tax_id_status"
    t.string "tax_id_origin"
    t.string "tax_id_fiscal_region"
    t.boolean "has_obit_indication"
    t.datetime "tax_id_status_date"
    t.datetime "tax_id_status_registration_date"
    t.datetime "creation_date"
    t.datetime "last_update_date"
    t.bigint "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_basic_datum_big_data_corp_id"
  end

  create_table "provenir_big_data_corps", force: :cascade do |t|
    t.string "raw_data"
    t.uuid "analysis_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["analysis_item_id"], name: "index_provenir_big_data_corps_on_analysis_item_id"
  end

  create_table "provenir_business_relationships", force: :cascade do |t|
    t.integer "total_relationships"
    t.integer "total_ownerships"
    t.integer "total_employments"
    t.integer "total_partners"
    t.integer "total_clients"
    t.integer "total_suppliers"
    t.bigint "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_business_relationship_big_data_corp_id"
  end

  create_table "provenir_business_relationships_items", force: :cascade do |t|
    t.string "related_entity_tax_id_number"
    t.string "related_entity_tax_id_type"
    t.string "related_entity_tax_id_country"
    t.string "related_entity_name"
    t.string "relationship_name"
    t.string "relationship_type"
    t.string "relationship_subtype"
    t.string "relationship_level"
    t.datetime "relationship_start_date"
    t.datetime "relationship_end_date"
    t.datetime "creation_date"
    t.datetime "last_update_date"
    t.string "additional_details"
    t.bigint "provenir_business_relationship_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_business_relationship_id"], name: "index_provenir_bus_rel_items_business_relationship_id"
  end

  create_table "provenir_collections", force: :cascade do |t|
    t.boolean "is_currently_on_collection"
    t.integer "last30_days_collection_occurrences"
    t.integer "last90_days_collection_occurrences"
    t.integer "last180_days_collection_occurrences"
    t.integer "last365_days_collection_occurrences"
    t.integer "last30_days_collection_origins"
    t.integer "last90_days_collection_origins"
    t.integer "last180_days_collection_origins"
    t.integer "last365_days_collection_origins"
    t.integer "total_collection_months"
    t.integer "current_consecutive_collection_months"
    t.integer "max_consecutive_collection_months"
    t.datetime "first_collection_date"
    t.datetime "last_collection_date"
    t.integer "collection_occurrences"
    t.integer "collection_origins"
    t.bigint "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_collection_big_data_corp_id"
  end

  create_table "provenir_decisions", force: :cascade do |t|
    t.text "decision_content"
    t.datetime "decision_date"
    t.bigint "provenir_lawsuit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_lawsuit_id"], name: "index_provenir_decision_lawsuit_id"
  end

  create_table "provenir_extended_addresses", force: :cascade do |t|
    t.integer "total_addresses"
    t.integer "total_active_addresses"
    t.integer "total_work_addresses"
    t.integer "total_personal_addresses"
    t.integer "total_unique_addresses"
    t.integer "total_address_passages"
    t.integer "total_bad_address_passages"
    t.datetime "oldest_address_passage_date"
    t.datetime "newest_address_passage_date"
    t.bigint "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_extended_address_big_data_corp_id"
  end

  create_table "provenir_extended_document_informations", force: :cascade do |t|
    t.bigint "provenir_basic_datum_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_basic_datum_id"], name: "index_provenir_extended_document_information_basic_datum_id"
  end

  create_table "provenir_extended_phones", force: :cascade do |t|
    t.integer "total_phones"
    t.integer "total_active_phones"
    t.integer "total_work_phones"
    t.integer "total_personal_phones"
    t.integer "total_unique_phones"
    t.integer "total_phone_passages"
    t.integer "total_bad_phone_passages"
    t.integer "total_last3_months_passages"
    t.integer "total_last6_months_passages"
    t.integer "total_last12_months_passages"
    t.integer "total_last16_months_passages", default: 0
    t.integer "total_last18_months_passages"
    t.datetime "oldest_phone_passage_date"
    t.datetime "newest_phone_passage_date"
    t.bigint "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_extended_phone_big_data_corp_id"
  end

  create_table "provenir_financial_data", force: :cascade do |t|
    t.string "total_assets"
    t.datetime "creation_date"
    t.datetime "last_update_date"
    t.bigint "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_financial_datum_big_data_corp_id"
  end

  create_table "provenir_financial_risks", force: :cascade do |t|
    t.string "total_assets"
    t.string "estimated_income_range"
    t.boolean "is_currently_employed"
    t.boolean "is_currently_owner"
    t.datetime "last_occupation_start_date"
    t.boolean "is_currently_on_collection"
    t.integer "last365_days_collection_occurrences"
    t.integer "current_consecutive_collection_months"
    t.boolean "is_currently_receiving_assistance"
    t.integer "financial_risk_score"
    t.string "financial_risk_level"
    t.bigint "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_financial_risk_big_data_corp_id"
  end

  create_table "provenir_income_estimates", force: :cascade do |t|
    t.string "mte"
    t.string "company_ownership"
    t.string "ibge"
    t.string "bigdata"
    t.string "bigdata_v2"
    t.bigint "provenir_financial_datum_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_financial_datum_id"], name: "index_provenir_income_estimate_financial_datum_id"
  end

  create_table "provenir_lawsuits", force: :cascade do |t|
    t.string "lawsuit_number"
    t.string "lawsuit_type"
    t.text "main_subject"
    t.string "court_name"
    t.string "court_level"
    t.string "court_type"
    t.string "court_district"
    t.string "judging_body"
    t.string "state"
    t.string "status"
    t.string "lawsuit_host_service"
    t.string "inferred_cnj_subject_name"
    t.string "inferred_cnj_subject_number"
    t.string "inferred_cnj_procedure_type_name"
    t.string "inferred_broad_cnj_subject_name"
    t.string "inferred_broad_cnj_subject_number"
    t.integer "number_of_volumes"
    t.integer "number_of_pages"
    t.string "value"
    t.datetime "res_judicata_date"
    t.datetime "close_date"
    t.datetime "redistribution_date"
    t.datetime "publication_date"
    t.datetime "notice_date"
    t.datetime "last_movement_date"
    t.datetime "capture_date"
    t.datetime "last_update"
    t.integer "number_of_parties"
    t.integer "number_of_updates"
    t.integer "law_suit_age"
    t.float "average_number_of_updates_per_month"
    t.string "reason_for_concealed_data"
    t.bigint "provenir_process_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_process_id"], name: "index_provenir_lawsuit_process_id"
  end

  create_table "provenir_parties", force: :cascade do |t|
    t.string "party_doc"
    t.boolean "is_party_active"
    t.string "name"
    t.string "polarity"
    t.string "party_type"
    t.datetime "last_capture_date"
    t.bigint "provenir_lawsuit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_lawsuit_id"], name: "index_provenir_party_lawsuit_id"
  end

  create_table "provenir_party_details", force: :cascade do |t|
    t.string "specific_type"
    t.bigint "provenir_party_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_party_id"], name: "index_provenir_party_detail_party_id"
  end

  create_table "provenir_personal_relationships", force: :cascade do |t|
    t.string "related_entity_tax_id_number"
    t.string "related_entity_tax_id_type"
    t.string "related_entity_tax_id_country"
    t.string "related_entity_name"
    t.string "relationship_type"
    t.string "relationship_level"
    t.datetime "relationship_start_date"
    t.datetime "relationship_end_date"
    t.datetime "creation_date"
    t.datetime "last_update_date"
    t.bigint "provenir_related_person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_related_person_id"], name: "index_provenir_personal_relationship_related_person_id"
  end

  create_table "provenir_petitions", force: :cascade do |t|
    t.bigint "provenir_lawsuit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_lawsuit_id"], name: "index_provenir_petition_lawsuit_id"
  end

  create_table "provenir_phones", force: :cascade do |t|
    t.string "number"
    t.string "complement"
    t.string "area_code"
    t.string "neighborhood"
    t.string "zip_code"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "phone_type"
    t.string "address_currently_in_rf_site"
    t.string "complement_type"
    t.string "build_code"
    t.string "building_code"
    t.string "household_code"
    t.string "address_entity_age"
    t.string "country_code"
    t.string "type_of_phone_plan", default: ""
    t.string "portability_history", default: ""
    t.string "validation_status", default: ""
    t.datetime "last_validation_date"
    t.datetime "first_passage_date_for_entity"
    t.datetime "last_passage_date_for_entity"
    t.datetime "first_passage_date_global"
    t.datetime "last_passage_date_global"
    t.datetime "creation_date"
    t.datetime "capture_date"
    t.boolean "phone_currently_in_rf_site"
    t.integer "phone_entity_total_passages"
    t.integer "phone_entity_bad_passages"
    t.integer "phone_entity_crawling_passages"
    t.integer "phone_entity_validation_passages"
    t.integer "phone_entity_query_passages"
    t.float "phone_entity_month_average_passages"
    t.integer "phone_global_age"
    t.integer "phone_global_total_passages"
    t.integer "phone_global_bad_passages"
    t.integer "phone_global_crawling_passages"
    t.integer "phone_global_validation_passages"
    t.integer "phone_global_query_passages"
    t.float "phone_global_month_average_passages"
    t.integer "last3_months_passages"
    t.integer "last6_months_passages"
    t.integer "last12_months_passages"
    t.integer "last16_months_passages", default: 0
    t.integer "last18_months_passages"
    t.integer "phone_number_of_entities"
    t.integer "phone_number_of_family_related_entities"
    t.integer "phone_number_of_related_entities"
    t.integer "priority"
    t.boolean "is_main_for_entity"
    t.boolean "is_recent_for_entity"
    t.boolean "is_main_for_other_entity"
    t.boolean "is_recent_for_other_entity"
    t.boolean "is_active"
    t.boolean "is_likely_from_accountant"
    t.boolean "is_in_do_not_call_list"
    t.boolean "has_opt_in", default: false
    t.string "current_carrier"
    t.bigint "provenir_extended_phone_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_extended_phone_id"], name: "index_provenir_phone_extended_phone_id"
  end

  create_table "provenir_processes", force: :cascade do |t|
    t.integer "lawsuits_total"
    t.integer "defendant_lawsuits_total"
    t.integer "plaintiff_lawsuits_total"
    t.bigint "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_process_big_data_corp_id"
  end

  create_table "provenir_related_people", force: :cascade do |t|
    t.integer "total_relationships"
    t.integer "total_relatives"
    t.integer "total_neighbors"
    t.integer "total_spouses"
    t.integer "total_coworkers"
    t.integer "total_household"
    t.integer "total_partners"
    t.integer "total_college_class"
    t.bigint "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_related_person_big_data_corp_id"
  end

  create_table "provenir_rgs", force: :cascade do |t|
    t.string "number"
    t.string "document_last4_digits"
    t.datetime "creation_date"
    t.datetime "last_update_date"
    t.bigint "provenir_extended_document_information_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_extended_document_information_id"], name: "index_big_data_rg_extended_document_information_id"
  end

  create_table "provenir_sources", force: :cascade do |t|
    t.string "state"
    t.string "ENADE"
    t.bigint "provenir_rg_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_rg_id"], name: "index_provenir_source_rg_id"
  end

  create_table "provenir_tax_returns", force: :cascade do |t|
    t.integer "year"
    t.string "status"
    t.string "bank"
    t.string "branch"
    t.string "batch"
    t.boolean "is_vip_branch"
    t.datetime "capture_date"
    t.datetime "creation_date"
    t.datetime "last_update_date"
    t.bigint "provenir_financial_datum_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_financial_datum_id"], name: "index_provenir_tax_return_financial_datum_id"
  end

  create_table "provenir_updates", force: :cascade do |t|
    t.text "content"
    t.datetime "publish_date"
    t.datetime "capture_date"
    t.bigint "provenir_lawsuit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_lawsuit_id"], name: "index_provenir_update_lawsuit_id"
  end

  create_table "request_logs", force: :cascade do |t|
    t.string "method"
    t.string "path"
    t.string "params"
    t.string "headers"
    t.string "body"
    t.string "options"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "response_logs", force: :cascade do |t|
    t.string "table", null: false
    t.string "table_pointer"
    t.string "path", null: false
    t.string "body"
    t.string "status", null: false
    t.string "method"
    t.string "headers"
    t.string "raw_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "serasa_addresses", force: :cascade do |t|
    t.string "address_line"
    t.string "district"
    t.string "zip_code"
    t.string "country"
    t.string "city"
    t.string "state"
    t.bigint "serasa_registration_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_registration_id"], name: "index_serasa_addresses_on_serasa_registration_id"
  end

  create_table "serasa_authentications", force: :cascade do |t|
    t.string "access_token"
    t.string "expires_in"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "serasa_check_items", force: :cascade do |t|
    t.date "occurrence_date"
    t.string "legal_square"
    t.integer "bank_id"
    t.string "bank_name"
    t.integer "bank_agency_id"
    t.integer "check_count"
    t.string "city"
    t.string "federal_unit"
    t.string "check_number"
    t.string "alinea"
    t.bigint "serasa_check_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_check_id"], name: "index_serasa_check_items_on_serasa_check_id"
  end

  create_table "serasa_checks", force: :cascade do |t|
    t.bigint "serasa_negative_data_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_negative_data_id"], name: "index_serasa_checks_on_serasa_negative_data_id"
  end

  create_table "serasa_facts", force: :cascade do |t|
    t.bigint "serasa_fintech_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_fintech_report_id"], name: "index_serasa_facts_on_serasa_fintech_report_id"
  end

  create_table "serasa_fintech_reports", force: :cascade do |t|
    t.string "raw_data"
    t.uuid "analysis_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["analysis_item_id"], name: "index_serasa_fintech_reports_on_analysis_item_id"
  end

  create_table "serasa_inquiries", force: :cascade do |t|
    t.bigint "serasa_fact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_fact_id"], name: "index_serasa_inquiries_on_serasa_fact_id"
  end

  create_table "serasa_inquiry_items", force: :cascade do |t|
    t.date "occurrence_date"
    t.integer "days_quantity"
    t.string "segment_description"
    t.bigint "serasa_inquiry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_inquiry_id"], name: "index_serasa_inquiry_items_on_serasa_inquiry_id"
  end

  create_table "serasa_negative_data", force: :cascade do |t|
    t.bigint "serasa_fintech_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_fintech_report_id"], name: "index_serasa_negative_data_on_serasa_fintech_report_id"
  end

  create_table "serasa_negative_items", force: :cascade do |t|
    t.date "occurrence_date"
    t.string "legal_nature_id"
    t.string "legal_nature"
    t.string "contract_id"
    t.string "creditor_name"
    t.float "amount"
    t.string "city"
    t.string "federal_unit"
    t.boolean "principal"
    t.string "owner_type"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_serasa_negative_items_on_owner"
  end

  create_table "serasa_notaries", force: :cascade do |t|
    t.bigint "serasa_negative_data_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_negative_data_id"], name: "index_serasa_notaries_on_serasa_negative_data_id"
  end

  create_table "serasa_notary_items", force: :cascade do |t|
    t.date "occurrence_date"
    t.float "amount"
    t.string "office_number"
    t.string "office_name"
    t.string "city"
    t.string "federal_unit"
    t.bigint "serasa_notary_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_notary_id"], name: "index_serasa_notary_items_on_serasa_notary_id"
  end

  create_table "serasa_pefins", force: :cascade do |t|
    t.bigint "serasa_negative_data_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_negative_data_id"], name: "index_serasa_pefins_on_serasa_negative_data_id"
  end

  create_table "serasa_phones", force: :cascade do |t|
    t.string "region_code"
    t.string "area_code"
    t.string "phone_number"
    t.string "owner_type"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_serasa_phones_on_owner"
  end

  create_table "serasa_refins", force: :cascade do |t|
    t.bigint "serasa_negative_data_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_negative_data_id"], name: "index_serasa_refins_on_serasa_negative_data_id"
  end

  create_table "serasa_registrations", force: :cascade do |t|
    t.string "document_number"
    t.string "consumer_name"
    t.string "mother_name"
    t.string "birth_date"
    t.string "status_registration"
    t.date "status_date"
    t.bigint "serasa_fintech_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_fintech_report_id"], name: "index_serasa_registrations_on_serasa_fintech_report_id"
  end

  create_table "serasa_scores", force: :cascade do |t|
    t.integer "score"
    t.string "score_model"
    t.string "range"
    t.string "default_rate"
    t.integer "code_message"
    t.string "message"
    t.bigint "serasa_fintech_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_fintech_report_id"], name: "index_serasa_scores_on_serasa_fintech_report_id"
  end

  create_table "serasa_stolen_document_items", force: :cascade do |t|
    t.date "occurrence_date"
    t.datetime "inclusion_date"
    t.string "document_type"
    t.string "document_number"
    t.string "issuing_authority"
    t.string "detailed_reason"
    t.string "occurrence_state"
    t.bigint "serasa_stolen_document_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_stolen_document_id"], name: "idx_on_serasa_stolen_document_id_e5dbecfd0e"
  end

  create_table "serasa_stolen_documents", force: :cascade do |t|
    t.date "occurrence_date"
    t.datetime "inclusion_date"
    t.string "document_type"
    t.string "document_number"
    t.string "issuing_authority"
    t.string "detailed_reason"
    t.string "occurrence_state"
    t.bigint "serasa_fact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_fact_id"], name: "index_serasa_stolen_documents_on_serasa_fact_id"
  end

  create_table "serasa_summaries", force: :cascade do |t|
    t.integer "count"
    t.float "balance"
    t.string "owner_type"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_serasa_summaries_on_owner"
  end

  add_foreign_key "analysis_item_steps", "analysis_items"
  add_foreign_key "analysis_item_steps", "analysis_steps"
  add_foreign_key "analysis_items", "analysis_items", column: "clone_of_id"
  add_foreign_key "analysis_items", "analysis_reports"
  add_foreign_key "analysis_predictions", "analysis_items"
  add_foreign_key "analysis_reports", "api_clients"
  add_foreign_key "api_webhook_events", "api_clients"
  add_foreign_key "boa_vista_additional_informations", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_addresses", "boa_vista_cadastral_locations"
  add_foreign_key "boa_vista_bank_branch_phones_addresses", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_basic_registrations", "boa_vista_cadastrals"
  add_foreign_key "boa_vista_cadastral_locations", "boa_vista_cadastrals"
  add_foreign_key "boa_vista_cadastral_qualifications", "boa_vista_cadastrals"
  add_foreign_key "boa_vista_cheque_additional_informations", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_cheque_stoppeds", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_cheques_stopped_for_reason21s", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_current_account_historics", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_debit_occurrences", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_debits", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_decisions", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_documents_names", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_historic_informed_cheques", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_identifications", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_list_of_returns_reported_by_ccfs", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_locations", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_phone_confirmations", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_phones", "boa_vista_cadastral_locations"
  add_foreign_key "boa_vista_previous90_days_consultations", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_previous_cheque_consultations", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_previous_queries", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_protested_title_summaries", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_protested_titles", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_record_messages", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_related_people", "boa_vista_cadastral_qualifications"
  add_foreign_key "boa_vista_returns_reported_by_users", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_score_rating_several_models", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_summary_devolution_reported_by_ccfs", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_summary_of_returns_reported_by_users", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_summary_previous_query_cheques", "boa_vista_acerta_essencials"
  add_foreign_key "boa_vista_zip_code_confirmations", "boa_vista_acerta_essencials"
  add_foreign_key "idwall_addresses", "idwall_reports"
  add_foreign_key "idwall_cpfs", "idwall_reports"
  add_foreign_key "idwall_related_people", "idwall_reports"
  add_foreign_key "idwall_reports", "analysis_items"
  add_foreign_key "idwall_trial_parts", "idwall_trials"
  add_foreign_key "idwall_trials", "idwall_reports"
  add_foreign_key "pro_score_bounced_checks", "pro_score_reports"
  add_foreign_key "pro_score_commercial_relations", "pro_score_reports"
  add_foreign_key "pro_score_criminal_antecedents", "pro_score_reports"
  add_foreign_key "pro_score_emergency_assistances", "pro_score_reports"
  add_foreign_key "pro_score_family_assistances", "pro_score_reports"
  add_foreign_key "pro_score_family_holdings", "pro_score_reports"
  add_foreign_key "pro_score_monthly_benefits", "pro_score_reports"
  add_foreign_key "pro_score_presumed_incomes", "pro_score_reports"
  add_foreign_key "pro_score_presumed_salary_ranges", "pro_score_reports"
  add_foreign_key "pro_score_proprable_professions", "pro_score_reports"
  add_foreign_key "pro_score_reports", "analysis_items"
  add_foreign_key "pro_score_trial_lawyers", "pro_score_trials"
  add_foreign_key "pro_score_trial_motions", "pro_score_trials"
  add_foreign_key "pro_score_trial_parts", "pro_score_trials"
  add_foreign_key "pro_score_trial_topics", "pro_score_trials"
  add_foreign_key "pro_score_trials", "pro_score_reports"
  add_foreign_key "provenir_addresses", "provenir_extended_addresses"
  add_foreign_key "provenir_aliases", "provenir_basic_data"
  add_foreign_key "provenir_alternative_id_numbers", "provenir_basic_data"
  add_foreign_key "provenir_basic_data", "provenir_big_data_corps"
  add_foreign_key "provenir_big_data_corps", "analysis_items"
  add_foreign_key "provenir_business_relationships", "provenir_big_data_corps"
  add_foreign_key "provenir_business_relationships_items", "provenir_business_relationships"
  add_foreign_key "provenir_collections", "provenir_big_data_corps"
  add_foreign_key "provenir_decisions", "provenir_lawsuits"
  add_foreign_key "provenir_extended_addresses", "provenir_big_data_corps"
  add_foreign_key "provenir_extended_document_informations", "provenir_basic_data"
  add_foreign_key "provenir_extended_phones", "provenir_big_data_corps"
  add_foreign_key "provenir_financial_data", "provenir_big_data_corps"
  add_foreign_key "provenir_financial_risks", "provenir_big_data_corps"
  add_foreign_key "provenir_income_estimates", "provenir_financial_data"
  add_foreign_key "provenir_lawsuits", "provenir_processes"
  add_foreign_key "provenir_parties", "provenir_lawsuits"
  add_foreign_key "provenir_party_details", "provenir_parties"
  add_foreign_key "provenir_personal_relationships", "provenir_related_people"
  add_foreign_key "provenir_petitions", "provenir_lawsuits"
  add_foreign_key "provenir_phones", "provenir_extended_phones"
  add_foreign_key "provenir_processes", "provenir_big_data_corps"
  add_foreign_key "provenir_related_people", "provenir_big_data_corps"
  add_foreign_key "provenir_rgs", "provenir_extended_document_informations"
  add_foreign_key "provenir_sources", "provenir_rgs"
  add_foreign_key "provenir_tax_returns", "provenir_financial_data"
  add_foreign_key "provenir_updates", "provenir_lawsuits"
  add_foreign_key "serasa_addresses", "serasa_registrations"
  add_foreign_key "serasa_check_items", "serasa_checks"
  add_foreign_key "serasa_checks", "serasa_negative_data", column: "serasa_negative_data_id"
  add_foreign_key "serasa_facts", "serasa_fintech_reports"
  add_foreign_key "serasa_fintech_reports", "analysis_items"
  add_foreign_key "serasa_inquiries", "serasa_facts"
  add_foreign_key "serasa_inquiry_items", "serasa_inquiries"
  add_foreign_key "serasa_negative_data", "serasa_fintech_reports"
  add_foreign_key "serasa_notaries", "serasa_negative_data", column: "serasa_negative_data_id"
  add_foreign_key "serasa_notary_items", "serasa_notaries"
  add_foreign_key "serasa_pefins", "serasa_negative_data", column: "serasa_negative_data_id"
  add_foreign_key "serasa_refins", "serasa_negative_data", column: "serasa_negative_data_id"
  add_foreign_key "serasa_registrations", "serasa_fintech_reports"
  add_foreign_key "serasa_scores", "serasa_fintech_reports"
  add_foreign_key "serasa_stolen_document_items", "serasa_stolen_documents"
  add_foreign_key "serasa_stolen_documents", "serasa_facts"
end
