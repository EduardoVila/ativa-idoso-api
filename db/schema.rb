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

ActiveRecord::Schema[8.0].define(version: 2026_05_20_001351) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"

  create_table "analysis_item_steps", force: :cascade do |t|
    t.bigint "analysis_item_id", null: false
    t.bigint "analysis_step_id", null: false
    t.datetime "created_at", null: false
    t.float "duration"
    t.integer "execution_status"
    t.datetime "finished_at"
    t.jsonb "result_summary", default: {}, null: false
    t.datetime "started_at"
    t.datetime "updated_at", null: false
    t.index ["analysis_item_id"], name: "index_analysis_item_steps_on_analysis_item_id"
    t.index ["analysis_step_id"], name: "index_analysis_item_steps_on_analysis_step_id"
  end

  create_table "analysis_items", force: :cascade do |t|
    t.bigint "analysis_report_id", null: false
    t.bigint "clone_of_id"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.integer "disapproval_situation"
    t.integer "error_status", default: 0
    t.jsonb "features", default: {}
    t.string "name"
    t.integer "status", default: 0
    t.jsonb "steps_data", default: {}, null: false
    t.datetime "updated_at", null: false
    t.index ["analysis_report_id"], name: "index_analysis_items_on_analysis_report_id"
    t.index ["clone_of_id"], name: "index_analysis_items_on_clone_of_id"
  end

  create_table "analysis_predictions", force: :cascade do |t|
    t.bigint "analysis_item_id", null: false
    t.boolean "approved"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.float "fee"
    t.jsonb "input_data"
    t.string "label"
    t.string "raw_data"
    t.datetime "updated_at", null: false
    t.index ["analysis_item_id"], name: "index_analysis_predictions_on_analysis_item_id"
  end

  create_table "analysis_reports", force: :cascade do |t|
    t.bigint "api_client_id", null: false
    t.boolean "approved"
    t.string "cpfs", array: true
    t.datetime "created_at", null: false
    t.integer "disapproval_situation"
    t.float "fee"
    t.string "payload"
    t.string "prediction_model_name"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.index ["api_client_id"], name: "index_analysis_reports_on_api_client_id"
    t.index ["prediction_model_name"], name: "index_analysis_reports_on_prediction_model_name"
  end

  create_table "analysis_steps", force: :cascade do |t|
    t.string "command_class"
    t.datetime "created_at", null: false
    t.boolean "enabled", default: true
    t.integer "index_order"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "analysis_tokens", force: :cascade do |t|
    t.string "access_token"
    t.datetime "created_at", null: false
    t.integer "expires_in"
    t.string "scope"
    t.string "token_type"
    t.datetime "updated_at", null: false
  end

  create_table "answers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "option_id", null: false
    t.string "complement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_answers_on_option_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "api_clients", force: :cascade do |t|
    t.string "client_id", null: false
    t.string "client_secret", null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.datetime "updated_at", null: false
    t.text "validators", default: ["blocked_negativity_validator", "exceeded_debits_validator", "protested_titles_validator", "provenir_has_obit_indication_validator", "provenir_family_holding_validator", "provenir_process_validator", "provenir_age_and_income_validator"], array: true
  end

  create_table "api_webhook_credentials", force: :cascade do |t|
    t.bigint "api_client_id", null: false
    t.string "auth_url"
    t.string "client_id"
    t.string "client_secret"
    t.datetime "created_at", null: false
    t.string "description"
    t.datetime "updated_at", null: false
    t.index ["api_client_id"], name: "index_api_webhook_credentials_on_api_client_id"
  end

  create_table "api_webhook_events", force: :cascade do |t|
    t.bigint "analysis_report_id"
    t.string "job_id"
    t.integer "status"
    t.jsonb "payload"
    t.jsonb "response"
    t.bigint "api_client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "api_webhook_subscription_id"
    t.bigint "callback_id"
    t.string "callback_url"
    t.string "event_type"
    t.index ["analysis_report_id"], name: "index_api_webhook_events_on_analysis_report_id"
    t.index ["api_client_id"], name: "index_api_webhook_events_on_api_client_id"
    t.index ["api_webhook_subscription_id"], name: "index_api_webhook_events_on_api_webhook_subscription_id"
    t.index ["callback_id"], name: "index_api_webhook_events_on_callback_id"
    t.index ["callback_url"], name: "index_api_webhook_events_on_callback_url"
    t.index ["event_type"], name: "index_api_webhook_events_on_event_type"
    t.index ["status"], name: "index_api_webhook_events_on_status"
  end

  create_table "api_webhook_subscriptions", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.bigint "api_webhook_credential_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "endpoint_url"
    t.integer "max_retries", default: 5, null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["api_webhook_credential_id"], name: "index_api_webhook_subscriptions_on_api_webhook_credential_id"
  end

  create_table "audits", force: :cascade do |t|
    t.string "class_name", null: false
    t.datetime "created_at"
    t.string "event", null: false
    t.string "ip"
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.text "object"
    t.bigint "owner_id"
    t.string "owner_type"
    t.string "user_agent"
    t.string "whodunnit"
    t.index ["class_name"], name: "index_audits_on_class_name"
    t.index ["item_type", "item_id"], name: "index_audits_on_item_type_and_item_id"
    t.index ["owner_type", "owner_id"], name: "index_audits_on_owner"
  end

  create_table "boa_vista_acerta_essencials", force: :cascade do |t|
    t.bigint "consumer_id", null: false
    t.string "consumer_type", null: false
    t.string "cpf", null: false
    t.datetime "created_at", null: false
    t.integer "credit_type", default: 0, null: false
    t.string "raw_data"
    t.datetime "updated_at", null: false
    t.index ["consumer_type", "consumer_id"], name: "index_boa_vista_acerta_essencials_on_consumer", unique: true
  end

  create_table "boa_vista_additional_informations", force: :cascade do |t|
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.string "fu_origin"
    t.string "information_type"
    t.string "origin"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.string "text"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_additional_information_on_acerta_essencial_id"
  end

  create_table "boa_vista_addresses", force: :cascade do |t|
    t.string "address_type"
    t.bigint "boa_vista_cadastral_location_id", null: false
    t.string "city"
    t.string "complement"
    t.datetime "created_at", null: false
    t.string "federal_unit"
    t.string "neighborhood"
    t.string "number"
    t.string "street"
    t.string "street_type"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["boa_vista_cadastral_location_id"], name: "index_boa_vista_addresses_on_boa_vista_cadastral_location_id"
  end

  create_table "boa_vista_bank_branch_phones_addresses", force: :cascade do |t|
    t.string "address"
    t.string "agency"
    t.string "agency_name"
    t.string "area_code"
    t.string "bank"
    t.string "bank_name"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.string "city"
    t.datetime "created_at", null: false
    t.string "federative_unit"
    t.string "neighborhood"
    t.string "phone_1"
    t.string "phone_2"
    t.string "plaza"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.string "reserved"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["boa_vista_acerta_essencial_id"], name: "idx_on_boa_vista_acerta_essencial_id_79c1bf7475", unique: true
  end

  create_table "boa_vista_basic_registrations", force: :cascade do |t|
    t.string "birth_date"
    t.bigint "boa_vista_cadastral_id", null: false
    t.string "cpf"
    t.string "cpf_situation"
    t.datetime "created_at", null: false
    t.string "exposed_person"
    t.string "mother_name"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_id"], name: "index_boa_vista_basic_registrations_on_boa_vista_cadastral_id", unique: true
  end

  create_table "boa_vista_cadastral_locations", force: :cascade do |t|
    t.bigint "boa_vista_cadastral_id", null: false
    t.string "cpf", null: false
    t.datetime "created_at", null: false
    t.string "emails", array: true
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_id"], name: "index_boa_vista_cadastral_locations_on_boa_vista_cadastral_id", unique: true
  end

  create_table "boa_vista_cadastral_qualifications", force: :cascade do |t|
    t.bigint "boa_vista_cadastral_id", null: false
    t.string "cpf", null: false
    t.datetime "created_at", null: false
    t.string "death"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_id"], name: "idx_on_boa_vista_cadastral_id_353e336e1f", unique: true
  end

  create_table "boa_vista_cadastrals", force: :cascade do |t|
    t.bigint "consumer_id", null: false
    t.string "consumer_type", null: false
    t.datetime "created_at", null: false
    t.string "raw_data"
    t.datetime "updated_at", null: false
    t.index ["consumer_type", "consumer_id"], name: "index_boa_vista_cadastrals_on_consumer", unique: true
  end

  create_table "boa_vista_cheque_additional_informations", force: :cascade do |t|
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.string "document_number"
    t.string "document_type"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.string "text"
    t.string "type_of_register"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_cheque_additional_info_on_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_cheque_stoppeds", force: :cascade do |t|
    t.string "agency"
    t.string "availability_date"
    t.string "bank"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.string "cheque"
    t.datetime "created_at", null: false
    t.string "current_account"
    t.string "document_number"
    t.string "document_type"
    t.string "indicator"
    t.string "informant"
    t.string "occurrence_date"
    t.string "occurrence_type"
    t.string "point"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_cheque_stopped_on_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_cheques_stopped_for_reason21s", force: :cascade do |t|
    t.string "agency"
    t.string "availability_date"
    t.string "bank"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.string "currency"
    t.string "current_account"
    t.string "document_number"
    t.string "document_type"
    t.string "final_cheque"
    t.string "informant"
    t.string "initial_cheque"
    t.string "occurrence_date"
    t.string "point"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["boa_vista_acerta_essencial_id"], name: "index_cheques_stopped_for_reason21_on_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_current_account_historics", force: :cascade do |t|
    t.string "agency"
    t.string "bank"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.string "consultation_date"
    t.string "consultation_hour"
    t.datetime "created_at", null: false
    t.string "current_account"
    t.string "document_number"
    t.string "document_type"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_current_account_historic_on_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_debit_occurrences", force: :cascade do |t|
    t.string "accumulated_value"
    t.string "biggest_debit_date"
    t.string "biggest_debit_value"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.string "first_debit_date"
    t.string "first_debit_value"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.string "total_debtor"
    t.string "total_guarantor"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_debit_occurrences_on_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_debits", force: :cascade do |t|
    t.string "availability_date"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.string "condition"
    t.string "contract"
    t.datetime "created_at", null: false
    t.string "currency", default: "0"
    t.string "informant"
    t.string "informed_by_querent"
    t.string "occurrence_date"
    t.string "occurrence_type"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.string "segment"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_debits_on_boa_vista_acerta_essencial_id"
  end

  create_table "boa_vista_decisions", force: :cascade do |t|
    t.string "approves"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.string "document"
    t.string "document_type"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.string "score"
    t.string "text"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_decisions_on_boa_vista_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_documents_names", force: :cascade do |t|
    t.string "birth_date"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.string "document_2"
    t.string "document_3"
    t.string "document_number"
    t.string "document_type"
    t.string "name"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_documents_names_on_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_historic_informed_cheques", force: :cascade do |t|
    t.string "agency"
    t.string "bank"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.string "cheque"
    t.string "consultation_date"
    t.string "consultation_hour"
    t.datetime "created_at", null: false
    t.string "current_account"
    t.string "document_number"
    t.string "document_type"
    t.string "network"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_historic_informed_cheque_on_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_identifications", force: :cascade do |t|
    t.string "birth_city"
    t.string "birth_date"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.string "consulted_gender"
    t.string "cpf_zone"
    t.datetime "created_at", null: false
    t.string "death"
    t.string "dependent_number"
    t.string "document"
    t.string "educational_level"
    t.string "emitting_organ"
    t.string "marital_status"
    t.string "mother_name"
    t.string "name"
    t.string "register"
    t.string "register_size"
    t.string "revenue_situation"
    t.string "rg_emitting_date"
    t.string "rg_federative_unit"
    t.string "rg_number"
    t.string "update_date"
    t.datetime "updated_at", null: false
    t.string "voter_title"
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_identifications_on_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_list_of_returns_reported_by_ccfs", force: :cascade do |t|
    t.string "agency"
    t.string "bank"
    t.string "bank_name"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.string "document_number"
    t.string "document_type"
    t.string "last_occurrence_12_date"
    t.string "last_occurrence_13_date"
    t.string "last_occurrence_14_date"
    t.string "last_occurrence_99_date"
    t.string "name"
    t.string "reason_12"
    t.string "reason_13"
    t.string "reason_14"
    t.string "reason_99"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_list_of_returns_reported_by_ccfs_on_acerta_essencial_id"
  end

  create_table "boa_vista_locations", force: :cascade do |t|
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.string "city"
    t.string "complement"
    t.datetime "created_at", null: false
    t.string "ddd_1"
    t.string "ddd_2"
    t.string "ddd_3"
    t.string "federative_unit"
    t.string "neighborhood"
    t.string "phone_1"
    t.string "phone_2"
    t.string "phone_3"
    t.string "public_place_name"
    t.string "public_place_number"
    t.string "public_place_type"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_locations_on_boa_vista_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_phone_confirmations", force: :cascade do |t|
    t.string "area_code"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.string "city"
    t.datetime "created_at", null: false
    t.string "document_number"
    t.string "document_type"
    t.string "federative_unit"
    t.string "name"
    t.string "neighborhood"
    t.string "phone"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["boa_vista_acerta_essencial_id"], name: "index_boa_vista_phone_confirmations_on_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_phones", force: :cascade do |t|
    t.bigint "boa_vista_cadastral_location_id", null: false
    t.datetime "created_at", null: false
    t.string "ddd"
    t.string "number"
    t.string "phone_type"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_location_id"], name: "index_boa_vista_phones_on_boa_vista_cadastral_location_id"
  end

  create_table "boa_vista_previous90_days_consultations", force: :cascade do |t|
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.string "month_1"
    t.string "month_2"
    t.string "month_3"
    t.string "month_4"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.string "total"
    t.string "total_1"
    t.string "total_2"
    t.string "total_3"
    t.string "total_4"
    t.datetime "updated_at", null: false
    t.string "year_1"
    t.string "year_2"
    t.string "year_3"
    t.string "year_4"
    t.index ["boa_vista_acerta_essencial_id"], name: "index_previous90_days_consultations_on_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_previous_cheque_consultations", force: :cascade do |t|
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.string "consultation_type"
    t.datetime "created_at", null: false
    t.string "credit_date"
    t.string "credit_hour"
    t.string "currency"
    t.string "document_number"
    t.string "document_type"
    t.string "informant"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["boa_vista_acerta_essencial_id"], name: "index_previous_cheque_consultations_on_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_previous_queries", force: :cascade do |t|
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.string "currency"
    t.string "date"
    t.string "informant"
    t.string "occurrence_type"
    t.string "product"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["boa_vista_acerta_essencial_id"], name: "index_previous_queries_on_acerta_essencial_id"
  end

  create_table "boa_vista_protested_title_summaries", force: :cascade do |t|
    t.string "accumulated_value"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.string "currency"
    t.string "federative_unit"
    t.string "final_period"
    t.string "initial_period"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.string "total"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "idx_on_boa_vista_acerta_essencial_id_f338e63983", unique: true
  end

  create_table "boa_vista_protested_titles", force: :cascade do |t|
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.string "city"
    t.datetime "created_at", null: false
    t.string "currency"
    t.string "federative_unit"
    t.string "occurrence_date"
    t.string "occurrence_type"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.string "registry"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["boa_vista_acerta_essencial_id"], name: "index_protested_titles_on_acerta_essencial_id"
  end

  create_table "boa_vista_record_messages", force: :cascade do |t|
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.string "record_reference"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.string "text"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_record_messages_on_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_related_people", force: :cascade do |t|
    t.bigint "boa_vista_cadastral_qualification_id", null: false
    t.string "cpf"
    t.datetime "created_at", null: false
    t.string "degree_of_kinship"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_cadastral_qualification_id"], name: "idx_on_boa_vista_cadastral_qualification_id_f3e4c504f2"
  end

  create_table "boa_vista_returns_reported_by_users", force: :cascade do |t|
    t.string "agency"
    t.string "bank"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.string "city"
    t.datetime "created_at", null: false
    t.string "currency"
    t.string "current_account"
    t.string "document"
    t.string "document_type"
    t.string "federative_unit"
    t.string "final_cheque"
    t.string "informant"
    t.string "informant_code"
    t.string "initial_cheque"
    t.string "occurrence_date"
    t.string "point"
    t.string "reason"
    t.string "register"
    t.string "register_date"
    t.string "register_size"
    t.string "register_type"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["boa_vista_acerta_essencial_id"], name: "index_returns_reported_by_users_on_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_score_rating_several_models", force: :cascade do |t|
    t.string "alphabetic_classification"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.string "code_kind_model"
    t.datetime "created_at", null: false
    t.string "kind_description"
    t.string "message"
    t.string "numeric_classification"
    t.string "plan_name"
    t.string "probability"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.string "score"
    t.string "score_model"
    t.string "score_name"
    t.string "score_type"
    t.string "text"
    t.string "text_2"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["boa_vista_acerta_essencial_id"], name: "index_score_rating_several_models_on_acerta_essencial_id"
  end

  create_table "boa_vista_summary_devolution_reported_by_ccfs", force: :cascade do |t|
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.string "devolution_total"
    t.string "document_number"
    t.string "document_type"
    t.string "name"
    t.string "names_total"
    t.string "reason_12"
    t.string "reason_13"
    t.string "reason_14"
    t.string "reason_99"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_summary_devolution_reported_by_ccf_on_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_summary_of_returns_reported_by_users", force: :cascade do |t|
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.string "document_number"
    t.string "document_type"
    t.string "first_devolution_date"
    t.string "last_devolution_date"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.string "total"
    t.datetime "updated_at", null: false
    t.index ["boa_vista_acerta_essencial_id"], name: "index_summary_of_return_reported_by_user_on_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_summary_previous_query_cheques", force: :cascade do |t|
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.datetime "created_at", null: false
    t.string "day"
    t.string "day_value"
    t.string "document_number"
    t.string "document_type"
    t.string "pre_dated"
    t.string "pre_dated_value"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.string "total"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["boa_vista_acerta_essencial_id"], name: "index_summary_previous_query_cheques_on_acerta_essencial_id", unique: true
  end

  create_table "boa_vista_zip_code_confirmations", force: :cascade do |t|
    t.string "address"
    t.bigint "boa_vista_acerta_essencial_id", null: false
    t.string "city"
    t.datetime "created_at", null: false
    t.string "federative_unit"
    t.string "neighborhood"
    t.string "register"
    t.string "register_size"
    t.string "register_type"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["boa_vista_acerta_essencial_id"], name: "index_zip_code_confirmations_on_acerta_essencial_id", unique: true
  end

  create_table "idwall_addresses", force: :cascade do |t|
    t.string "city"
    t.datetime "created_at", null: false
    t.bigint "idwall_report_id", null: false
    t.string "kind"
    t.string "main"
    t.string "neighborhood"
    t.string "number"
    t.string "people_at_address"
    t.string "state"
    t.string "street"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["idwall_report_id"], name: "index_idwall_addresses_on_idwall_report_id"
  end

  create_table "idwall_cpfs", force: :cascade do |t|
    t.string "birth_date"
    t.string "cpf_cadastral_situation"
    t.string "cpf_subscription_date"
    t.string "cpf_verifying_digit"
    t.datetime "created_at", null: false
    t.string "gender"
    t.bigint "idwall_report_id", null: false
    t.string "income"
    t.string "income_tax_situation"
    t.string "name"
    t.string "number"
    t.string "social_name"
    t.string "source"
    t.datetime "updated_at", null: false
    t.string "year_of_death"
    t.index ["idwall_report_id"], name: "index_idwall_cpfs_on_idwall_report_id", unique: true
  end

  create_table "idwall_related_people", force: :cascade do |t|
    t.string "cpf"
    t.datetime "created_at", null: false
    t.bigint "idwall_report_id", null: false
    t.string "kind"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["idwall_report_id"], name: "index_idwall_related_people_on_idwall_report_id"
  end

  create_table "idwall_reports", force: :cascade do |t|
    t.bigint "analysis_item_id", null: false
    t.datetime "created_at", null: false
    t.string "number", null: false
    t.string "raw_data"
    t.integer "status", default: 0
    t.datetime "updated_at", null: false
    t.index ["analysis_item_id"], name: "index_idwall_reports_on_analysis_item_id", unique: true
  end

  create_table "idwall_trial_parts", force: :cascade do |t|
    t.string "birth_date"
    t.string "cnpj"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.string "gender"
    t.bigint "idwall_trial_id", null: false
    t.string "kind"
    t.string "name"
    t.string "rg"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["idwall_trial_id"], name: "index_idwall_trial_parts_on_idwall_trial_id"
  end

  create_table "idwall_trials", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "idwall_report_id", null: false
    t.string "kind"
    t.string "subject"
    t.datetime "updated_at", null: false
    t.index ["idwall_report_id"], name: "index_idwall_trials_on_idwall_report_id"
  end

  create_table "lawsuit_banned_keywords", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "keyword"
    t.integer "litigation_category", default: 0
    t.datetime "updated_at", null: false
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

  create_table "prediction_tokens", force: :cascade do |t|
    t.string "access_token"
    t.datetime "created_at", null: false
    t.integer "expires_in"
    t.string "scope"
    t.string "token_type"
    t.datetime "updated_at", null: false
  end

  create_table "pro_score_authentications", force: :cascade do |t|
    t.string "access_token"
    t.datetime "created_at", null: false
    t.integer "expires_in"
    t.string "refresh_token"
    t.string "token_type"
    t.datetime "updated_at", null: false
  end

  create_table "pro_score_bounced_checks", force: :cascade do |t|
    t.string "codigo_do_banco"
    t.datetime "created_at", null: false
    t.string "data_da_ultima_ocorrencia"
    t.string "motivo_da_ocorrencia"
    t.string "nome_do_banco"
    t.string "numero_da_agencia"
    t.string "numero_plugin"
    t.bigint "pro_score_report_id", null: false
    t.string "quantidade_de_ocorrencias"
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_bounced_checks_on_pro_score_report_id"
  end

  create_table "pro_score_commercial_relations", force: :cascade do |t|
    t.string "cpfcnpj"
    t.datetime "created_at", null: false
    t.string "numero_plugin"
    t.bigint "pro_score_report_id", null: false
    t.string "razao_social"
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_commercial_relations_on_pro_score_report_id"
  end

  create_table "pro_score_criminal_antecedents", force: :cascade do |t|
    t.string "certidao"
    t.datetime "created_at", null: false
    t.string "data_da_emissao"
    t.string "hora_da_emissao"
    t.string "numero_da_certidao"
    t.string "numero_plugin"
    t.bigint "pro_score_report_id", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_criminal_antecedents_on_pro_score_report_id"
  end

  create_table "pro_score_emergency_assistances", force: :cascade do |t|
    t.string "codigo_do_municipio"
    t.datetime "created_at", null: false
    t.string "enquadramento"
    t.string "mes_disponibilizado"
    t.string "municipio"
    t.string "numero_plugin"
    t.string "observacao"
    t.string "parcelas"
    t.bigint "pro_score_report_id", null: false
    t.string "uf"
    t.datetime "updated_at", null: false
    t.string "valor"
    t.index ["pro_score_report_id"], name: "index_pro_score_emergency_assistances_on_pro_score_report_id"
  end

  create_table "pro_score_family_assistances", force: :cascade do |t|
    t.string "consta_beneficio"
    t.datetime "created_at", null: false
    t.string "numero_plugin"
    t.bigint "pro_score_report_id", null: false
    t.string "ultima_data_do_beneficio"
    t.datetime "updated_at", null: false
    t.string "valor"
    t.index ["pro_score_report_id"], name: "index_pro_score_family_assistances_on_pro_score_report_id"
  end

  create_table "pro_score_family_holdings", force: :cascade do |t|
    t.string "cpf_do_parente"
    t.datetime "created_at", null: false
    t.string "grau_de_parentesco"
    t.string "nome_do_parente"
    t.string "numero_plugin"
    t.bigint "pro_score_report_id", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_family_holdings_on_pro_score_report_id"
  end

  create_table "pro_score_monthly_benefits", force: :cascade do |t|
    t.string "beneficio_concedido_judicialmente"
    t.datetime "created_at", null: false
    t.string "mes_competencia"
    t.string "mes_referencia"
    t.string "nis_beneficiario"
    t.string "nome_municipio"
    t.string "numero_beneficio"
    t.string "numero_plugin"
    t.bigint "pro_score_report_id", null: false
    t.string "uf"
    t.datetime "updated_at", null: false
    t.string "valor_parcela"
    t.index ["pro_score_report_id"], name: "index_pro_score_monthly_benefits_on_pro_score_report_id"
  end

  create_table "pro_score_presumed_incomes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "numero_plugin"
    t.bigint "pro_score_report_id", null: false
    t.datetime "updated_at", null: false
    t.string "valor_da_renda_presumida"
    t.index ["pro_score_report_id"], name: "index_pro_score_presumed_incomes_on_pro_score_report_id", unique: true
  end

  create_table "pro_score_presumed_salary_ranges", force: :cascade do |t|
    t.string "codigo_da_faixa_salarial"
    t.datetime "created_at", null: false
    t.string "descricao_da_faixa"
    t.string "faixa_salarial"
    t.string "numero_plugin"
    t.bigint "pro_score_report_id", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_presumed_salary_ranges_on_pro_score_report_id", unique: true
  end

  create_table "pro_score_proprable_professions", force: :cascade do |t|
    t.string "codigo"
    t.datetime "created_at", null: false
    t.string "numero_plugin"
    t.bigint "pro_score_report_id", null: false
    t.string "titulo"
    t.datetime "updated_at", null: false
    t.index ["pro_score_report_id"], name: "index_pro_score_proprable_professions_on_pro_score_report_id", unique: true
  end

  create_table "pro_score_reports", force: :cascade do |t|
    t.bigint "analysis_item_id", null: false
    t.datetime "created_at", null: false
    t.text "performed_searches", default: [], array: true
    t.string "raw_data"
    t.datetime "updated_at", null: false
    t.index ["analysis_item_id"], name: "index_pro_score_reports_on_analysis_item_id", unique: true
  end

  create_table "pro_score_trial_lawyers", force: :cascade do |t|
    t.string "advogado_nome"
    t.string "cnpj"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.string "numero_do_processo_unico"
    t.string "numero_plugin"
    t.string "oab_numero"
    t.string "oab_uf"
    t.string "parte_nome"
    t.bigint "pro_score_trial_id", null: false
    t.string "tipo"
    t.datetime "updated_at", null: false
    t.index ["pro_score_trial_id"], name: "index_pro_score_trial_lawyers_on_pro_score_trial_id"
  end

  create_table "pro_score_trial_motions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "data"
    t.string "nome_original"
    t.string "numero_do_processo_unico"
    t.string "numero_plugin"
    t.bigint "pro_score_trial_id", null: false
    t.datetime "updated_at", null: false
    t.index ["pro_score_trial_id"], name: "index_pro_score_trial_motions_on_pro_score_trial_id"
  end

  create_table "pro_score_trial_parts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "documento"
    t.string "nome"
    t.string "numero_do_processo_unico"
    t.string "numero_plugin"
    t.string "polo"
    t.bigint "pro_score_trial_id", null: false
    t.string "tipo"
    t.datetime "updated_at", null: false
    t.index ["pro_score_trial_id"], name: "index_pro_score_trial_parts_on_pro_score_trial_id"
  end

  create_table "pro_score_trial_topics", force: :cascade do |t|
    t.string "codigo_cnpj"
    t.datetime "created_at", null: false
    t.string "numero_do_processo_unico"
    t.string "numero_plugin"
    t.bigint "pro_score_trial_id", null: false
    t.string "titulo"
    t.datetime "updated_at", null: false
    t.index ["pro_score_trial_id"], name: "index_pro_score_trial_topics_on_pro_score_trial_id"
  end

  create_table "pro_score_trials", force: :cascade do |t|
    t.string "area"
    t.string "causa_moeda"
    t.string "causa_valor"
    t.string "classe_processual_nome"
    t.datetime "created_at", null: false
    t.datetime "data_distribuicao"
    t.datetime "data_processamento"
    t.string "juiz"
    t.string "numero_do_processo_unico"
    t.string "numero_plugin"
    t.string "orgao_julgador"
    t.bigint "pro_score_report_id", null: false
    t.string "segmento"
    t.string "sistema"
    t.string "tribunal"
    t.string "uf"
    t.string "unidade_origem"
    t.datetime "updated_at", null: false
    t.string "url_processo"
    t.index ["pro_score_report_id"], name: "index_pro_score_trials_on_pro_score_report_id"
  end

  create_table "provenir_addresses", force: :cascade do |t|
    t.string "address_currently_in_rf_site"
    t.integer "address_entity_age"
    t.integer "address_entity_bad_passages"
    t.integer "address_entity_crawling_passages"
    t.float "address_entity_month_average_passages"
    t.integer "address_entity_query_passages"
    t.integer "address_entity_total_passages"
    t.integer "address_entity_validation_passages"
    t.integer "address_global_age"
    t.integer "address_global_bad_passages"
    t.integer "address_global_crawling_passages"
    t.float "address_global_month_average_passages"
    t.integer "address_global_query_passages"
    t.integer "address_global_total_passages"
    t.integer "address_global_validation_passages"
    t.string "address_main"
    t.integer "address_number_of_entities"
    t.string "address_type"
    t.string "build_code"
    t.string "building_code"
    t.datetime "capture_date"
    t.string "city"
    t.string "complement"
    t.string "complement_type"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "creation_date"
    t.datetime "entity_first_passage_date"
    t.datetime "entity_last_passage_date"
    t.datetime "global_first_passage_date"
    t.datetime "global_last_passage_date"
    t.boolean "has_opt_in"
    t.string "household_code"
    t.boolean "is_active"
    t.boolean "is_likely_from_accountant"
    t.boolean "is_main_for_entity"
    t.boolean "is_main_for_other_entity"
    t.boolean "is_ratified"
    t.boolean "is_recent_for_entity"
    t.boolean "is_recent_for_other_entity"
    t.integer "last12_months_passages", default: 0
    t.integer "last16_months_passages", default: 0
    t.integer "last3_months_passages", default: 0
    t.integer "last6_months_passages", default: 0
    t.datetime "last_update_date"
    t.datetime "last_validation_date"
    t.float "latitude"
    t.float "longitude"
    t.integer "match_rate", default: 0
    t.string "neighborhood"
    t.string "number"
    t.integer "priority"
    t.bigint "provenir_extended_address_id", null: false
    t.string "state"
    t.string "title"
    t.string "typology"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["provenir_extended_address_id"], name: "index_provenir_address_extended_address_id"
  end

  create_table "provenir_aliases", force: :cascade do |t|
    t.string "common_name"
    t.datetime "created_at", null: false
    t.bigint "provenir_basic_datum_id", null: false
    t.string "standardized_name"
    t.datetime "updated_at", null: false
    t.index ["provenir_basic_datum_id"], name: "index_provenir_alias_basic_datum_id"
  end

  create_table "provenir_alternative_id_numbers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "document_number"
    t.string "document_type"
    t.bigint "provenir_basic_datum_id", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_basic_datum_id"], name: "index_provenir_alternative_id_number_basic_datum_id"
  end

  create_table "provenir_basic_data", force: :cascade do |t|
    t.integer "age"
    t.string "birth_country"
    t.datetime "birth_date"
    t.string "chinese_sign"
    t.datetime "created_at", null: false
    t.datetime "creation_date"
    t.string "father_name"
    t.integer "first_and_last_name_uniqueness_score"
    t.integer "first_name_uniqueness_score"
    t.string "gender"
    t.boolean "has_obit_indication"
    t.datetime "last_update_date"
    t.string "marital_status_data"
    t.string "mother_name"
    t.string "name"
    t.integer "name_uniqueness_score"
    t.integer "name_word_count"
    t.integer "number_of_full_name_namesakes"
    t.bigint "provenir_big_data_corp_id", null: false
    t.string "tax_id_country"
    t.string "tax_id_fiscal_region"
    t.string "tax_id_number"
    t.string "tax_id_origin"
    t.string "tax_id_status"
    t.datetime "tax_id_status_date"
    t.datetime "tax_id_status_registration_date"
    t.datetime "updated_at", null: false
    t.string "zodiac_sign"
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_basic_datum_big_data_corp_id", unique: true
  end

  create_table "provenir_big_data_corps", force: :cascade do |t|
    t.bigint "analysis_item_id", null: false
    t.datetime "created_at", null: false
    t.string "raw_data"
    t.datetime "updated_at", null: false
    t.index ["analysis_item_id"], name: "index_provenir_big_data_corps_on_analysis_item_id", unique: true
  end

  create_table "provenir_business_relationships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "provenir_big_data_corp_id", null: false
    t.integer "total_clients"
    t.integer "total_employments"
    t.integer "total_ownerships"
    t.integer "total_partners"
    t.integer "total_relationships"
    t.integer "total_suppliers"
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_business_relationship_big_data_corp_id", unique: true
  end

  create_table "provenir_business_relationships_items", force: :cascade do |t|
    t.string "additional_details"
    t.datetime "created_at", null: false
    t.datetime "creation_date"
    t.datetime "last_update_date"
    t.bigint "provenir_business_relationship_id", null: false
    t.string "related_entity_name"
    t.string "related_entity_tax_id_country"
    t.string "related_entity_tax_id_number"
    t.string "related_entity_tax_id_type"
    t.datetime "relationship_end_date"
    t.string "relationship_level"
    t.string "relationship_name"
    t.datetime "relationship_start_date"
    t.string "relationship_subtype"
    t.string "relationship_type"
    t.datetime "updated_at", null: false
    t.index ["provenir_business_relationship_id"], name: "index_provenir_bus_rel_items_business_relationship_id"
  end

  create_table "provenir_collections", force: :cascade do |t|
    t.integer "collection_occurrences"
    t.integer "collection_origins"
    t.datetime "created_at", null: false
    t.integer "current_consecutive_collection_months"
    t.datetime "first_collection_date"
    t.boolean "is_currently_on_collection"
    t.integer "last180_days_collection_occurrences"
    t.integer "last180_days_collection_origins"
    t.integer "last30_days_collection_occurrences"
    t.integer "last30_days_collection_origins"
    t.integer "last365_days_collection_occurrences"
    t.integer "last365_days_collection_origins"
    t.integer "last90_days_collection_occurrences"
    t.integer "last90_days_collection_origins"
    t.datetime "last_collection_date"
    t.integer "max_consecutive_collection_months"
    t.bigint "provenir_big_data_corp_id", null: false
    t.integer "total_collection_months"
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_collection_big_data_corp_id", unique: true
  end

  create_table "provenir_decisions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "decision_content"
    t.datetime "decision_date"
    t.bigint "provenir_lawsuit_id", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_lawsuit_id"], name: "index_provenir_decision_lawsuit_id"
  end

  create_table "provenir_extended_addresses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "newest_address_passage_date"
    t.datetime "oldest_address_passage_date"
    t.bigint "provenir_big_data_corp_id", null: false
    t.integer "total_active_addresses"
    t.integer "total_address_passages"
    t.integer "total_addresses"
    t.integer "total_bad_address_passages"
    t.integer "total_personal_addresses"
    t.integer "total_unique_addresses"
    t.integer "total_work_addresses"
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_extended_address_big_data_corp_id", unique: true
  end

  create_table "provenir_extended_document_informations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "provenir_basic_datum_id", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_basic_datum_id"], name: "index_provenir_extended_document_information_basic_datum_id"
  end

  create_table "provenir_extended_phones", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "newest_phone_passage_date"
    t.datetime "oldest_phone_passage_date"
    t.bigint "provenir_big_data_corp_id", null: false
    t.integer "total_active_phones"
    t.integer "total_bad_phone_passages"
    t.integer "total_last12_months_passages"
    t.integer "total_last16_months_passages", default: 0
    t.integer "total_last18_months_passages"
    t.integer "total_last3_months_passages"
    t.integer "total_last6_months_passages"
    t.integer "total_personal_phones"
    t.integer "total_phone_passages"
    t.integer "total_phones"
    t.integer "total_unique_phones"
    t.integer "total_work_phones"
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_extended_phone_big_data_corp_id", unique: true
  end

  create_table "provenir_financial_data", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "creation_date"
    t.datetime "last_update_date"
    t.bigint "provenir_big_data_corp_id", null: false
    t.string "total_assets"
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_financial_datum_big_data_corp_id", unique: true
  end

  create_table "provenir_financial_risks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "current_consecutive_collection_months"
    t.string "estimated_income_range"
    t.string "financial_risk_level"
    t.integer "financial_risk_score"
    t.boolean "is_currently_employed"
    t.boolean "is_currently_on_collection"
    t.boolean "is_currently_owner"
    t.boolean "is_currently_receiving_assistance"
    t.integer "last365_days_collection_occurrences"
    t.datetime "last_occupation_start_date"
    t.bigint "provenir_big_data_corp_id", null: false
    t.string "total_assets"
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_financial_risk_big_data_corp_id", unique: true
  end

  create_table "provenir_income_estimates", force: :cascade do |t|
    t.string "bigdata"
    t.string "bigdata_v2"
    t.string "company_ownership"
    t.datetime "created_at", null: false
    t.string "ibge"
    t.string "mte"
    t.bigint "provenir_financial_datum_id", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_financial_datum_id"], name: "index_provenir_income_estimate_financial_datum_id", unique: true
  end

  create_table "provenir_lawsuits", force: :cascade do |t|
    t.float "average_number_of_updates_per_month"
    t.datetime "capture_date"
    t.datetime "close_date"
    t.string "court_district"
    t.string "court_level"
    t.string "court_name"
    t.string "court_type"
    t.datetime "created_at", null: false
    t.string "inferred_broad_cnj_subject_name"
    t.string "inferred_broad_cnj_subject_number"
    t.string "inferred_cnj_procedure_type_name"
    t.string "inferred_cnj_subject_name"
    t.string "inferred_cnj_subject_number"
    t.string "judging_body"
    t.datetime "last_movement_date"
    t.datetime "last_update"
    t.integer "law_suit_age"
    t.string "lawsuit_host_service"
    t.string "lawsuit_number"
    t.string "lawsuit_type"
    t.text "main_subject"
    t.datetime "notice_date"
    t.integer "number_of_pages"
    t.integer "number_of_parties"
    t.integer "number_of_updates"
    t.integer "number_of_volumes"
    t.bigint "provenir_process_id", null: false
    t.datetime "publication_date"
    t.string "reason_for_concealed_data"
    t.datetime "redistribution_date"
    t.datetime "res_judicata_date"
    t.string "state"
    t.string "status"
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["provenir_process_id"], name: "index_provenir_lawsuit_process_id"
  end

  create_table "provenir_parties", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_party_active"
    t.datetime "last_capture_date"
    t.string "name"
    t.string "party_doc"
    t.string "party_type"
    t.string "polarity"
    t.bigint "provenir_lawsuit_id", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_lawsuit_id"], name: "index_provenir_party_lawsuit_id"
  end

  create_table "provenir_party_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "provenir_party_id", null: false
    t.string "specific_type"
    t.datetime "updated_at", null: false
    t.index ["provenir_party_id"], name: "index_provenir_party_detail_party_id", unique: true
  end

  create_table "provenir_personal_relationships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "creation_date"
    t.datetime "last_update_date"
    t.bigint "provenir_related_person_id", null: false
    t.string "related_entity_name"
    t.string "related_entity_tax_id_country"
    t.string "related_entity_tax_id_number"
    t.string "related_entity_tax_id_type"
    t.datetime "relationship_end_date"
    t.string "relationship_level"
    t.datetime "relationship_start_date"
    t.string "relationship_type"
    t.datetime "updated_at", null: false
    t.index ["provenir_related_person_id"], name: "index_provenir_personal_relationship_related_person_id"
  end

  create_table "provenir_petitions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "provenir_lawsuit_id", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_lawsuit_id"], name: "index_provenir_petition_lawsuit_id"
  end

  create_table "provenir_phones", force: :cascade do |t|
    t.string "address_currently_in_rf_site"
    t.string "address_entity_age"
    t.string "area_code"
    t.string "build_code"
    t.string "building_code"
    t.datetime "capture_date"
    t.string "city"
    t.string "complement"
    t.string "complement_type"
    t.string "country"
    t.string "country_code"
    t.datetime "created_at", null: false
    t.datetime "creation_date"
    t.string "current_carrier"
    t.datetime "first_passage_date_for_entity"
    t.datetime "first_passage_date_global"
    t.boolean "has_opt_in", default: false
    t.string "household_code"
    t.boolean "is_active"
    t.boolean "is_in_do_not_call_list"
    t.boolean "is_likely_from_accountant"
    t.boolean "is_main_for_entity"
    t.boolean "is_main_for_other_entity"
    t.boolean "is_recent_for_entity"
    t.boolean "is_recent_for_other_entity"
    t.integer "last12_months_passages"
    t.integer "last16_months_passages", default: 0
    t.integer "last18_months_passages"
    t.integer "last3_months_passages"
    t.integer "last6_months_passages"
    t.datetime "last_passage_date_for_entity"
    t.datetime "last_passage_date_global"
    t.datetime "last_validation_date"
    t.string "neighborhood"
    t.string "number"
    t.boolean "phone_currently_in_rf_site"
    t.integer "phone_entity_bad_passages"
    t.integer "phone_entity_crawling_passages"
    t.float "phone_entity_month_average_passages"
    t.integer "phone_entity_query_passages"
    t.integer "phone_entity_total_passages"
    t.integer "phone_entity_validation_passages"
    t.integer "phone_global_age"
    t.integer "phone_global_bad_passages"
    t.integer "phone_global_crawling_passages"
    t.float "phone_global_month_average_passages"
    t.integer "phone_global_query_passages"
    t.integer "phone_global_total_passages"
    t.integer "phone_global_validation_passages"
    t.integer "phone_number_of_entities"
    t.integer "phone_number_of_family_related_entities"
    t.integer "phone_number_of_related_entities"
    t.string "phone_type"
    t.string "portability_history", default: ""
    t.integer "priority"
    t.bigint "provenir_extended_phone_id", null: false
    t.string "state"
    t.string "type_of_phone_plan", default: ""
    t.datetime "updated_at", null: false
    t.string "validation_status", default: ""
    t.string "zip_code"
    t.index ["provenir_extended_phone_id"], name: "index_provenir_phone_extended_phone_id"
  end

  create_table "provenir_processes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "defendant_lawsuits_total"
    t.integer "lawsuits_total"
    t.integer "plaintiff_lawsuits_total"
    t.bigint "provenir_big_data_corp_id", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_process_big_data_corp_id", unique: true
  end

  create_table "provenir_related_people", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "provenir_big_data_corp_id", null: false
    t.integer "total_college_class"
    t.integer "total_coworkers"
    t.integer "total_household"
    t.integer "total_neighbors"
    t.integer "total_partners"
    t.integer "total_relationships"
    t.integer "total_relatives"
    t.integer "total_spouses"
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_related_person_big_data_corp_id", unique: true
  end

  create_table "provenir_rgs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "creation_date"
    t.string "document_last4_digits"
    t.datetime "last_update_date"
    t.string "number"
    t.bigint "provenir_extended_document_information_id", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_extended_document_information_id"], name: "index_big_data_rg_extended_document_information_id", unique: true
  end

  create_table "provenir_sources", force: :cascade do |t|
    t.string "ENADE"
    t.datetime "created_at", null: false
    t.bigint "provenir_rg_id", null: false
    t.string "state"
    t.datetime "updated_at", null: false
    t.index ["provenir_rg_id"], name: "index_provenir_source_rg_id", unique: true
  end

  create_table "provenir_tax_returns", force: :cascade do |t|
    t.string "bank"
    t.string "batch"
    t.string "branch"
    t.datetime "capture_date"
    t.datetime "created_at", null: false
    t.datetime "creation_date"
    t.boolean "is_vip_branch"
    t.datetime "last_update_date"
    t.bigint "provenir_financial_datum_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.integer "year"
    t.index ["provenir_financial_datum_id"], name: "index_provenir_tax_return_financial_datum_id"
  end

  create_table "provenir_updates", force: :cascade do |t|
    t.datetime "capture_date"
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "provenir_lawsuit_id", null: false
    t.datetime "publish_date"
    t.datetime "updated_at", null: false
    t.index ["provenir_lawsuit_id"], name: "index_provenir_update_lawsuit_id"
  end

  create_table "public_keys", force: :cascade do |t|
    t.string "algorithm", null: false
    t.datetime "created_at", null: false
    t.string "issuer", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.datetime "valid_from", null: false
    t.datetime "valid_to", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "description", null: false
    t.bigint "research_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["research_id"], name: "index_questions_on_research_id"
  end

  create_table "request_logs", force: :cascade do |t|
    t.string "body"
    t.datetime "created_at", null: false
    t.string "headers"
    t.string "method"
    t.string "options"
    t.string "params"
    t.string "path"
    t.datetime "updated_at", null: false
  end

  create_table "research_and_development_analysis_items", force: :cascade do |t|
    t.string "analysis_items_cpf"
    t.integer "analysis_items_status"
    t.integer "analysis_items_error_status"
    t.datetime "analysis_items_created_at"
    t.integer "analysis_items_analysis_report_id"
    t.integer "analysis_items_payment_situation"
    t.string "analysis_items_name"
    t.integer "analysis_item_disapproval_situation"
    t.integer "analysis_item_clone_of_id"
    t.string "bv_acerta_essencials_cpf"
    t.integer "bv_acerta_essencials_credit_type"
    t.string "bv_acerta_essencials_consumer_type"
    t.integer "bv_acerta_essencials_consumer_id"
    t.jsonb "bv_additional_informations"
    t.jsonb "bv_debits"
    t.jsonb "bv_protested_titles"
    t.string "bv_protested_title_summaries_register_size"
    t.string "bv_protested_title_summaries_register_type"
    t.string "bv_protested_title_summaries_register"
    t.string "bv_protested_title_summaries_total"
    t.string "bv_protested_title_summaries_initial_period"
    t.string "bv_protested_title_summaries_final_period"
    t.string "bv_protested_title_summaries_currency"
    t.string "bv_protested_title_summaries_accumulated_value"
    t.string "bv_protested_title_summaries_federative_unit"
    t.integer "bv_protested_title_summaries_boa_vista_acerta_essencial_id"
    t.string "bv_identifications_register_size"
    t.string "bv_identifications_register"
    t.string "bv_identifications_document"
    t.string "bv_identifications_name"
    t.string "bv_identifications_mother_name"
    t.string "bv_identifications_birth_date"
    t.string "bv_identifications_rg_number"
    t.string "bv_identifications_emitting_organ"
    t.string "bv_identifications_rg_federative_unit"
    t.string "bv_identifications_rg_emitting_date"
    t.string "bv_identifications_consulted_gender"
    t.string "bv_identifications_birth_city"
    t.string "bv_identifications_marital_status"
    t.string "bv_identifications_dependent_number"
    t.string "bv_identifications_educational_level"
    t.string "bv_identifications_revenue_situation"
    t.string "bv_identifications_update_date"
    t.string "bv_identifications_cpf_zone"
    t.string "bv_identifications_voter_title"
    t.string "bv_identifications_death"
    t.integer "bv_identifications_boa_vista_acerta_essencial_id"
    t.string "bv_debit_occurrences_register_size"
    t.string "bv_debit_occurrences_register_type"
    t.string "bv_debit_occurrences_register"
    t.string "bv_debit_occurrences_total_debtor"
    t.string "bv_debit_occurrences_total_guarantor"
    t.string "bv_debit_occurrences_accumulated_value"
    t.string "bv_debit_occurrences_first_debit_date"
    t.string "bv_debit_occurrences_first_debit_value"
    t.string "bv_debit_occurrences_biggest_debit_date"
    t.string "bv_debit_occurrences_biggest_debit_value"
    t.integer "bv_debit_occurrences_boa_vista_acerta_essencial_id"
    t.string "bv_locations_register_size"
    t.string "bv_locations_register_type"
    t.string "bv_locations_register"
    t.string "bv_locations_public_place_type"
    t.string "bv_locations_public_place_name"
    t.string "bv_locations_public_place_number"
    t.string "bv_locations_complement"
    t.string "bv_locations_neighborhood"
    t.string "bv_locations_city"
    t.string "bv_locations_federative_unit"
    t.string "bv_locations_zip_code"
    t.string "bv_locations_ddd_1"
    t.string "bv_locations_phone_1"
    t.string "bv_locations_ddd_2"
    t.string "bv_locations_phone_2"
    t.string "bv_locations_ddd_3"
    t.string "bv_locations_phone_3"
    t.integer "bv_locations_boa_vista_acerta_essencial_id"
    t.jsonb "bv_previous_queries"
    t.string "bv_cheque_additional_informations_register_size"
    t.string "bv_cheque_additional_informations_register_type"
    t.string "bv_cheque_additional_informations_register"
    t.string "bv_cheque_additional_informations_document_type"
    t.string "bv_cheque_additional_informations_document_number"
    t.string "bv_cheque_additional_informations_text"
    t.string "bv_cheque_additional_informations_type_of_register"
    t.integer "bv_cheque_additional_informations_boa_vista_acerta_essencial_id"
    t.string "bv_current_account_historics_register_size"
    t.string "bv_current_account_historics_register_type"
    t.string "bv_current_account_historics_register"
    t.string "bv_current_account_historics_bank"
    t.string "bv_current_account_historics_agency"
    t.string "bv_current_account_historics_current_account"
    t.string "bv_current_account_historics_document_type"
    t.string "bv_current_account_historics_document_number"
    t.string "bv_current_account_historics_consultation_date"
    t.string "bv_current_account_historics_consultation_hour"
    t.integer "bv_current_account_historics_boa_vista_acerta_essencial_id"
    t.string "bv_decisions_register_size"
    t.string "bv_decisions_register_type"
    t.string "bv_decisions_register"
    t.string "bv_decisions_document_type"
    t.string "bv_decisions_document"
    t.string "bv_decisions_score"
    t.string "bv_decisions_approves"
    t.string "bv_decisions_text"
    t.integer "bv_decisions_boa_vista_acerta_essencial_id"
    t.string "bv_zip_code_confirmations_register_size"
    t.string "bv_zip_code_confirmations_register_type"
    t.string "bv_zip_code_confirmations_register"
    t.string "bv_zip_code_confirmations_zip_code"
    t.string "bv_zip_code_confirmations_address"
    t.string "bv_zip_code_confirmations_neighborhood"
    t.string "bv_zip_code_confirmations_city"
    t.string "bv_zip_code_confirmations_federative_unit"
    t.integer "bv_zip_code_confirmations_boa_vista_acerta_essencial_id"
    t.string "bv_documents_names_register_size"
    t.string "bv_documents_names_register_type"
    t.string "bv_documents_names_register"
    t.string "bv_documents_names_name"
    t.string "bv_documents_names_birth_date"
    t.string "bv_documents_names_document_type"
    t.string "bv_documents_names_document_number"
    t.string "bv_documents_names_document_2"
    t.string "bv_documents_names_document_3"
    t.integer "bv_documents_names_boa_vista_acerta_essencial_id"
    t.jsonb "bv_list_of_returns_reported_by_ccfs"
    t.string "bv_returns_reported_by_users_register_size"
    t.string "bv_returns_reported_by_users_register_type"
    t.string "bv_returns_reported_by_users_register"
    t.string "bv_returns_reported_by_users_document_type"
    t.string "bv_returns_reported_by_users_document"
    t.string "bv_returns_reported_by_users_bank"
    t.string "bv_returns_reported_by_users_agency"
    t.string "bv_returns_reported_by_users_current_account"
    t.string "bv_returns_reported_by_users_initial_cheque"
    t.string "bv_returns_reported_by_users_final_cheque"
    t.string "bv_returns_reported_by_users_reason"
    t.string "bv_returns_reported_by_users_point"
    t.string "bv_returns_reported_by_users_occurrence_date"
    t.string "bv_returns_reported_by_users_register_date"
    t.string "bv_returns_reported_by_users_currency"
    t.string "bv_returns_reported_by_users_value"
    t.string "bv_returns_reported_by_users_informant_code"
    t.string "bv_returns_reported_by_users_informant"
    t.string "bv_returns_reported_by_users_city"
    t.string "bv_returns_reported_by_users_federative_unit"
    t.integer "bv_returns_reported_by_users_boa_vista_acerta_essencial_id"
    t.string "bv_cheques_stopped_for_reason21s_register_size"
    t.string "bv_cheques_stopped_for_reason21s_register_type"
    t.string "bv_cheques_stopped_for_reason21s_register"
    t.string "bv_cheques_stopped_for_reason21s_document_type"
    t.string "bv_cheques_stopped_for_reason21s_document_number"
    t.string "bv_cheques_stopped_for_reason21s_bank"
    t.string "bv_cheques_stopped_for_reason21s_agency"
    t.string "bv_cheques_stopped_for_reason21s_current_account"
    t.string "bv_cheques_stopped_for_reason21s_initial_cheque"
    t.string "bv_cheques_stopped_for_reason21s_final_cheque"
    t.string "bv_cheques_stopped_for_reason21s_point"
    t.string "bv_cheques_stopped_for_reason21s_occurrence_date"
    t.string "bv_cheques_stopped_for_reason21s_availability_date"
    t.string "bv_cheques_stopped_for_reason21s_currency"
    t.string "bv_cheques_stopped_for_reason21s_value"
    t.string "bv_cheques_stopped_for_reason21s_informant"
    t.integer "bv_cheques_stopped_for_reason21s_boa_vista_acerta_essencial_id"
    t.string "bv_historic_informed_cheques_register_size"
    t.string "bv_historic_informed_cheques_register_type"
    t.string "bv_historic_informed_cheques_register"
    t.string "bv_historic_informed_cheques_document_type"
    t.string "bv_historic_informed_cheques_document_number"
    t.string "bv_historic_informed_cheques_bank"
    t.string "bv_historic_informed_cheques_agency"
    t.string "bv_historic_informed_cheques_current_account"
    t.string "bv_historic_informed_cheques_cheque"
    t.string "bv_historic_informed_cheques_consultation_date"
    t.string "bv_historic_informed_cheques_consultation_hour"
    t.string "bv_historic_informed_cheques_network"
    t.integer "bv_historic_informed_cheques_boa_vista_acerta_essencial_id"
    t.string "bv_previous_cheque_consultations_register_size"
    t.string "bv_previous_cheque_consultations_register_type"
    t.string "bv_previous_cheque_consultations_register"
    t.string "bv_previous_cheque_consultations_document_type"
    t.string "bv_previous_cheque_consultations_document_number"
    t.string "bv_previous_cheque_consultations_consultation_type"
    t.string "bv_previous_cheque_consultations_credit_date"
    t.string "bv_previous_cheque_consultations_credit_hour"
    t.string "bv_previous_cheque_consultations_currency"
    t.string "bv_previous_cheque_consultations_value"
    t.string "bv_previous_cheque_consultations_informant"
    t.integer "bv_previous_cheque_consultations_boa_vista_acerta_essencial_id"
    t.string "bv_summary_of_returns_reported_by_users_register_size"
    t.string "bv_summary_of_returns_reported_by_users_register_type"
    t.string "bv_summary_of_returns_reported_by_users_register"
    t.string "bv_summary_of_returns_reported_by_users_document_type"
    t.string "bv_summary_of_returns_reported_by_users_document_number"
    t.string "bv_summary_of_returns_reported_by_users_total"
    t.string "bv_summary_of_returns_reported_by_users_first_devolution_date"
    t.string "bv_summary_of_returns_reported_by_users_last_devolution_date"
    t.integer "bv_summary_of_returns_reported_by_users_boa_vista_acerta_essenc"
    t.jsonb "bv_score_rating_several_models"
    t.string "bv_record_messages_register_size"
    t.string "bv_record_messages_register_type"
    t.string "bv_record_messages_register"
    t.string "bv_record_messages_record_reference"
    t.string "bv_record_messages_text"
    t.integer "bv_record_messages_boa_vista_acerta_essencial_id"
    t.string "bv_previous90_days_consultations_register_size"
    t.string "bv_previous90_days_consultations_register_type"
    t.string "bv_previous90_days_consultations_register"
    t.string "bv_previous90_days_consultations_total"
    t.string "bv_previous90_days_consultations_year_1"
    t.string "bv_previous90_days_consultations_month_1"
    t.string "bv_previous90_days_consultations_total_1"
    t.string "bv_previous90_days_consultations_year_2"
    t.string "bv_previous90_days_consultations_month_2"
    t.string "bv_previous90_days_consultations_total_2"
    t.string "bv_previous90_days_consultations_year_3"
    t.string "bv_previous90_days_consultations_month_3"
    t.string "bv_previous90_days_consultations_total_3"
    t.string "bv_previous90_days_consultations_year_4"
    t.string "bv_previous90_days_consultations_month_4"
    t.string "bv_previous90_days_consultations_total_4"
    t.integer "bv_previous90_days_consultations_boa_vista_acerta_essencial_id"
    t.string "bv_cheque_stoppeds_register_size"
    t.string "bv_cheque_stoppeds_register_type"
    t.string "bv_cheque_stoppeds_register"
    t.string "bv_cheque_stoppeds_occurrence_type"
    t.string "bv_cheque_stoppeds_document_type"
    t.string "bv_cheque_stoppeds_document_number"
    t.string "bv_cheque_stoppeds_bank"
    t.string "bv_cheque_stoppeds_agency"
    t.string "bv_cheque_stoppeds_current_account"
    t.string "bv_cheque_stoppeds_cheque"
    t.string "bv_cheque_stoppeds_point"
    t.string "bv_cheque_stoppeds_occurrence_date"
    t.string "bv_cheque_stoppeds_availability_date"
    t.string "bv_cheque_stoppeds_informant"
    t.string "bv_cheque_stoppeds_indicator"
    t.integer "bv_cheque_stoppeds_boa_vista_acerta_essencial_id"
    t.string "bv_summary_devolution_reported_by_ccfs_register_size"
    t.string "bv_summary_devolution_reported_by_ccfs_register_type"
    t.string "bv_summary_devolution_reported_by_ccfs_register"
    t.string "bv_summary_devolution_reported_by_ccfs_document_type"
    t.string "bv_summary_devolution_reported_by_ccfs_document_number"
    t.string "bv_summary_devolution_reported_by_ccfs_name"
    t.string "bv_summary_devolution_reported_by_ccfs_names_total"
    t.string "bv_summary_devolution_reported_by_ccfs_devolution_total"
    t.string "bv_summary_devolution_reported_by_ccfs_reason_12"
    t.string "bv_summary_devolution_reported_by_ccfs_reason_13"
    t.string "bv_summary_devolution_reported_by_ccfs_reason_14"
    t.string "bv_summary_devolution_reported_by_ccfs_reason_99"
    t.integer "bv_summary_devolution_reported_by_ccfs_boa_vista_acerta_essenci"
    t.string "bv_summary_previous_query_cheques_register_size"
    t.string "bv_summary_previous_query_cheques_register_type"
    t.string "bv_summary_previous_query_cheques_register"
    t.string "bv_summary_previous_query_cheques_document_type"
    t.string "bv_summary_previous_query_cheques_document_number"
    t.string "bv_summary_previous_query_cheques_total"
    t.string "bv_summary_previous_query_cheques_value"
    t.string "bv_summary_previous_query_cheques_day"
    t.string "bv_summary_previous_query_cheques_day_value"
    t.string "bv_summary_previous_query_cheques_pre_dated"
    t.string "bv_summary_previous_query_cheques_pre_dated_value"
    t.integer "bv_summary_previous_query_cheques_boa_vista_acerta_essencial_id"
    t.string "bv_phone_confirmations_register_size"
    t.string "bv_phone_confirmations_register_type"
    t.string "bv_phone_confirmations_register"
    t.string "bv_phone_confirmations_area_code"
    t.string "bv_phone_confirmations_phone"
    t.string "bv_phone_confirmations_document_type"
    t.string "bv_phone_confirmations_document_number"
    t.string "bv_phone_confirmations_name"
    t.string "bv_phone_confirmations_neighborhood"
    t.string "bv_phone_confirmations_zip_code"
    t.string "bv_phone_confirmations_city"
    t.string "bv_phone_confirmations_federative_unit"
    t.integer "bv_phone_confirmations_boa_vista_acerta_essencial_id"
    t.string "bv_bank_branch_phones_addresses_register_size"
    t.string "bv_bank_branch_phones_addresses_register_type"
    t.string "bv_bank_branch_phones_addresses_register"
    t.string "bv_bank_branch_phones_addresses_bank"
    t.string "bv_bank_branch_phones_addresses_bank_name"
    t.string "bv_bank_branch_phones_addresses_agency"
    t.string "bv_bank_branch_phones_addresses_agency_name"
    t.string "bv_bank_branch_phones_addresses_address"
    t.string "bv_bank_branch_phones_addresses_neighborhood"
    t.string "bv_bank_branch_phones_addresses_zip_code"
    t.string "bv_bank_branch_phones_addresses_city"
    t.string "bv_bank_branch_phones_addresses_federative_unit"
    t.string "bv_bank_branch_phones_addresses_plaza"
    t.string "bv_bank_branch_phones_addresses_area_code"
    t.string "bv_bank_branch_phones_addresses_phone_1"
    t.string "bv_bank_branch_phones_addresses_phone_2"
    t.string "bv_bank_branch_phones_addresses_reserved"
    t.integer "bv_bank_branch_phones_addresses_boa_vista_acerta_essencial_id"
    t.string "idwall_reports_number"
    t.integer "idwall_reports_status"
    t.integer "idwall_reports_analysis_item_id"
    t.string "idwall_cpfs_gender"
    t.string "idwall_cpfs_number"
    t.string "idwall_cpfs_birth_date"
    t.string "idwall_cpfs_source"
    t.string "idwall_cpfs_name"
    t.string "idwall_cpfs_income"
    t.string "idwall_cpfs_income_tax_situation"
    t.string "idwall_cpfs_cpf_cadastral_situation"
    t.string "idwall_cpfs_cpf_subscription_date"
    t.string "idwall_cpfs_cpf_verifying_digit"
    t.string "idwall_cpfs_year_of_death"
    t.string "idwall_cpfs_social_name"
    t.integer "idwall_cpfs_idwall_report_id"
    t.jsonb "idwall_trials"
    t.jsonb "idwall_addresses"
    t.jsonb "idwall_related_people"
    t.integer "ps_reports_analysis_item_id"
    t.text "ps_reports_performed_searches"
    t.jsonb "ps_trials"
    t.jsonb "ps_family_assistances"
    t.jsonb "ps_emergency_assistances"
    t.jsonb "ps_monthly_benefits"
    t.jsonb "ps_family_holdings"
    t.jsonb "ps_bounced_checks"
    t.jsonb "ps_commercial_relations"
    t.jsonb "ps_criminal_antecedents"
    t.string "ps_proprable_professions_codigo"
    t.string "ps_proprable_professions_titulo"
    t.string "ps_proprable_professions_numero_plugin"
    t.integer "ps_proprable_professions_pro_analysis_id"
    t.string "ps_presumed_salary_ranges_numero_plugin"
    t.string "ps_presumed_salary_ranges_codigo_da_faixa_salarial"
    t.string "ps_presumed_salary_ranges_faixa_salarial"
    t.string "ps_presumed_salary_ranges_descricao_da_faixa"
    t.integer "ps_presumed_salary_ranges_pro_analysis_id"
    t.string "ps_presumed_incomes_numero_plugin"
    t.string "ps_presumed_incomes_valor_da_renda_presumida"
    t.integer "ps_presumed_incomes_pro_analysis_id"
    t.string "bv_cadastrals_consumer_type"
    t.integer "bv_cadastrals_consumer_id"
    t.string "bv_basic_registrations_cpf"
    t.string "bv_basic_registrations_name"
    t.string "bv_basic_registrations_mother_name"
    t.integer "bv_basic_registrations_boa_vista_cadastral_id"
    t.date "bv_basic_registrations_birth_date"
    t.boolean "bv_basic_registrations_exposed_person"
    t.string "bv_basic_registrations_cpf_situation"
    t.string "bv_cadastral_locations_cpf"
    t.integer "bv_cadastral_locations_boa_vista_cadastral_id"
    t.string "bv_cadastral_locations_emails"
    t.jsonb "bv_addresses"
    t.jsonb "bv_phones"
    t.string "bv_cadastral_qualifications_cpf"
    t.string "bv_cadastral_qualifications_death"
    t.integer "bv_cadastral_qualifications_boa_vista_cadastral_id"
    t.jsonb "bv_related_people"
    t.integer "srs_fintech_reports_analysis_item_id"
    t.string "srs_registrations_document_number"
    t.string "srs_registrations_consumer_name"
    t.string "srs_registrations_mother_name"
    t.string "srs_registrations_birth_date"
    t.string "srs_registrations_status_registration"
    t.integer "srs_registrations_serasa_fintech_report_id"
    t.date "srs_registrations_status_date"
    t.string "srs_addresses_address_line"
    t.string "srs_addresses_district"
    t.string "srs_addresses_zip_code"
    t.string "srs_addresses_country"
    t.string "srs_addresses_city"
    t.string "srs_addresses_state"
    t.integer "srs_addresses_serasa_registration_id"
    t.string "srs_phones_region_code"
    t.string "srs_phones_area_code"
    t.string "srs_phones_phone_number"
    t.string "srs_phones_owner_type"
    t.integer "srs_phones_owner_id"
    t.integer "srs_negative_data_serasa_fintech_report_id"
    t.integer "srs_pefins_serasa_negative_data_id"
    t.jsonb "srs_negative_items"
    t.integer "srs_summaries_count"
    t.float "srs_summaries_balance"
    t.string "srs_summaries_owner_type"
    t.integer "srs_summaries_owner_id"
    t.integer "srs_refins_serasa_negative_data_id"
    t.integer "srs_notaries_serasa_negative_data_id"
    t.jsonb "srs_notary_items"
    t.integer "srs_checks_serasa_negative_data_id"
    t.jsonb "srs_check_items"
    t.integer "srs_scores_score"
    t.string "srs_scores_score_model"
    t.string "srs_scores_range"
    t.string "srs_scores_default_rate"
    t.integer "srs_scores_code_message"
    t.string "srs_scores_message"
    t.integer "srs_scores_serasa_fintech_report_id"
    t.integer "srs_facts_serasa_fintech_report_id"
    t.integer "srs_inquiries_serasa_fact_id"
    t.jsonb "srs_inquiry_items"
    t.integer "srs_stolen_documents_serasa_fact_id"
    t.jsonb "srs_stolen_document_items"
    t.integer "prv_big_data_corps_analysis_item_id"
    t.string "prv_basic_data_tax_id_number"
    t.string "prv_basic_data_tax_id_country"
    t.string "prv_basic_data_name"
    t.string "prv_basic_data_gender"
    t.integer "prv_basic_data_name_word_count"
    t.integer "prv_basic_data_number_of_full_name_namesakes"
    t.integer "prv_basic_data_name_uniqueness_score"
    t.integer "prv_basic_data_first_name_uniqueness_score"
    t.integer "prv_basic_data_first_and_last_name_uniqueness_score"
    t.datetime "prv_basic_data_birth_date"
    t.integer "prv_basic_data_age"
    t.string "prv_basic_data_zodiac_sign"
    t.string "prv_basic_data_chinese_sign"
    t.string "prv_basic_data_birth_country"
    t.string "prv_basic_data_mother_name"
    t.string "prv_basic_data_father_name"
    t.string "prv_basic_data_marital_status_data"
    t.string "prv_basic_data_tax_id_status"
    t.string "prv_basic_data_tax_id_origin"
    t.string "prv_basic_data_tax_id_fiscal_region"
    t.boolean "prv_basic_data_has_obit_indication"
    t.datetime "prv_basic_data_tax_id_status_date"
    t.datetime "prv_basic_data_tax_id_status_registration_date"
    t.datetime "prv_basic_data_creation_date"
    t.datetime "prv_basic_data_last_update_date"
    t.integer "prv_basic_data_provenir_big_data_corp_id"
    t.integer "prv_alternative_id_numbers_provenir_basic_datum_id"
    t.string "prv_alternative_id_numbers_document_type"
    t.string "prv_alternative_id_numbers_document_number"
    t.integer "prv_extended_document_informations_provenir_basic_datum_id"
    t.string "prv_rgs_document_last4_digits"
    t.datetime "prv_rgs_creation_date"
    t.datetime "prv_rgs_last_update_date"
    t.integer "prv_rgs_provenir_extended_document_information_id"
    t.string "prv_rgs_number"
    t.string "prv_sources_ENADE"
    t.integer "prv_sources_provenir_rg_id"
    t.string "prv_sources_state"
    t.string "prv_aliases_common_name"
    t.string "prv_aliases_standardized_name"
    t.integer "prv_aliases_provenir_basic_datum_id"
    t.integer "prv_extended_addresses_total_addresses"
    t.integer "prv_extended_addresses_total_active_addresses"
    t.integer "prv_extended_addresses_total_work_addresses"
    t.integer "prv_extended_addresses_total_personal_addresses"
    t.integer "prv_extended_addresses_total_unique_addresses"
    t.integer "prv_extended_addresses_total_address_passages"
    t.integer "prv_extended_addresses_total_bad_address_passages"
    t.datetime "prv_extended_addresses_oldest_address_passage_date"
    t.datetime "prv_extended_addresses_newest_address_passage_date"
    t.integer "prv_extended_addresses_provenir_big_data_corp_id"
    t.jsonb "prv_addresses"
    t.integer "prv_extended_phones_total_phones"
    t.integer "prv_extended_phones_total_active_phones"
    t.integer "prv_extended_phones_total_work_phones"
    t.integer "prv_extended_phones_total_personal_phones"
    t.integer "prv_extended_phones_total_unique_phones"
    t.integer "prv_extended_phones_total_phone_passages"
    t.integer "prv_extended_phones_total_bad_phone_passages"
    t.integer "prv_extended_phones_total_last3_months_passages"
    t.integer "prv_extended_phones_total_last6_months_passages"
    t.integer "prv_extended_phones_total_last12_months_passages"
    t.integer "prv_extended_phones_total_last18_months_passages"
    t.datetime "prv_extended_phones_oldest_phone_passage_date"
    t.datetime "prv_extended_phones_newest_phone_passage_date"
    t.integer "prv_extended_phones_provenir_big_data_corp_id"
    t.integer "prv_extended_phones_total_last16_months_passages"
    t.jsonb "prv_phones"
    t.string "prv_financial_data_total_assets"
    t.datetime "prv_financial_data_creation_date"
    t.datetime "prv_financial_data_last_update_date"
    t.integer "prv_financial_data_provenir_big_data_corp_id"
    t.string "prv_income_estimates_mte"
    t.string "prv_income_estimates_company_ownership"
    t.string "prv_income_estimates_ibge"
    t.string "prv_income_estimates_bigdata"
    t.string "prv_income_estimates_bigdata_v2"
    t.integer "prv_income_estimates_provenir_financial_datum_id"
    t.jsonb "prv_tax_returns"
    t.string "prv_financial_risks_total_assets"
    t.string "prv_financial_risks_estimated_income_range"
    t.boolean "prv_financial_risks_is_currently_employed"
    t.boolean "prv_financial_risks_is_currently_owner"
    t.datetime "prv_financial_risks_last_occupation_start_date"
    t.boolean "prv_financial_risks_is_currently_on_collection"
    t.integer "prv_financial_risks_last365_days_collection_occurrences"
    t.integer "prv_financial_risks_current_consecutive_collection_months"
    t.boolean "prv_financial_risks_is_currently_receiving_assistance"
    t.integer "prv_financial_risks_financial_risk_score"
    t.string "prv_financial_risks_financial_risk_level"
    t.integer "prv_financial_risks_provenir_big_data_corp_id"
    t.integer "prv_processes_provenir_big_data_corp_id"
    t.integer "prv_processes_lawsuits_total"
    t.integer "prv_processes_defendant_lawsuits_total"
    t.integer "prv_processes_plaintiff_lawsuits_total"
    t.jsonb "prv_lawsuits"
    t.integer "prv_related_people_total_relationships"
    t.integer "prv_related_people_total_relatives"
    t.integer "prv_related_people_total_neighbors"
    t.integer "prv_related_people_total_spouses"
    t.integer "prv_related_people_total_coworkers"
    t.integer "prv_related_people_total_household"
    t.integer "prv_related_people_total_partners"
    t.integer "prv_related_people_total_college_class"
    t.integer "prv_related_people_provenir_big_data_corp_id"
    t.jsonb "prv_personal_relationships"
    t.boolean "prv_collections_is_currently_on_collection"
    t.integer "prv_collections_last30_days_collection_occurrences"
    t.integer "prv_collections_last90_days_collection_occurrences"
    t.integer "prv_collections_last180_days_collection_occurrences"
    t.integer "prv_collections_last365_days_collection_occurrences"
    t.integer "prv_collections_last30_days_collection_origins"
    t.integer "prv_collections_last90_days_collection_origins"
    t.integer "prv_collections_last180_days_collection_origins"
    t.integer "prv_collections_last365_days_collection_origins"
    t.integer "prv_collections_total_collection_months"
    t.integer "prv_collections_current_consecutive_collection_months"
    t.integer "prv_collections_max_consecutive_collection_months"
    t.datetime "prv_collections_first_collection_date"
    t.datetime "prv_collections_last_collection_date"
    t.integer "prv_collections_collection_occurrences"
    t.integer "prv_collections_collection_origins"
    t.integer "prv_collections_provenir_big_data_corp_id"
    t.integer "prv_business_relationships_total_relationships"
    t.integer "prv_business_relationships_total_ownerships"
    t.integer "prv_business_relationships_total_employments"
    t.integer "prv_business_relationships_total_partners"
    t.integer "prv_business_relationships_total_clients"
    t.integer "prv_business_relationships_total_suppliers"
    t.integer "prv_business_relationships_provenir_big_data_corp_id"
    t.jsonb "prv_business_relationships_items"
    t.jsonb "predictions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["analysis_item_clone_of_id"], name: "r_n_d_clone_of_id_index"
    t.index ["analysis_items_analysis_report_id"], name: "r_n_d_analysis_report_id_index"
    t.index ["analysis_items_cpf"], name: "r_n_d_analysis_item_cpf_index"
    t.index ["analysis_items_payment_situation"], name: "r_n_d_payment_situation_index"
  end

  create_table "researches", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "response_logs", force: :cascade do |t|
    t.string "body"
    t.datetime "created_at", null: false
    t.string "headers"
    t.string "method"
    t.string "path", null: false
    t.string "raw_data"
    t.string "status", null: false
    t.string "table", null: false
    t.string "table_pointer"
    t.datetime "updated_at", null: false
  end

  create_table "serasa_addresses", force: :cascade do |t|
    t.string "address_line"
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "district"
    t.bigint "serasa_registration_id", null: false
    t.string "state"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["serasa_registration_id"], name: "index_serasa_addresses_on_serasa_registration_id", unique: true
  end

  create_table "serasa_authentications", force: :cascade do |t|
    t.string "access_token"
    t.datetime "created_at", null: false
    t.string "expires_in"
    t.datetime "updated_at", null: false
  end

  create_table "serasa_check_items", force: :cascade do |t|
    t.string "alinea"
    t.integer "bank_agency_id"
    t.integer "bank_id"
    t.string "bank_name"
    t.integer "check_count"
    t.string "check_number"
    t.string "city"
    t.datetime "created_at", null: false
    t.string "federal_unit"
    t.string "legal_square"
    t.date "occurrence_date"
    t.bigint "serasa_check_id", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_check_id"], name: "index_serasa_check_items_on_serasa_check_id"
  end

  create_table "serasa_checks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "serasa_negative_data_id", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_negative_data_id"], name: "index_serasa_checks_on_serasa_negative_data_id", unique: true
  end

  create_table "serasa_facts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "serasa_fintech_report_id", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_fintech_report_id"], name: "index_serasa_facts_on_serasa_fintech_report_id", unique: true
  end

  create_table "serasa_fintech_reports", force: :cascade do |t|
    t.bigint "analysis_item_id", null: false
    t.datetime "created_at", null: false
    t.string "raw_data"
    t.datetime "updated_at", null: false
    t.index ["analysis_item_id"], name: "index_serasa_fintech_reports_on_analysis_item_id", unique: true
  end

  create_table "serasa_inquiries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "serasa_fact_id", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_fact_id"], name: "index_serasa_inquiries_on_serasa_fact_id", unique: true
  end

  create_table "serasa_inquiry_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "days_quantity"
    t.date "occurrence_date"
    t.string "segment_description"
    t.bigint "serasa_inquiry_id", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_inquiry_id"], name: "index_serasa_inquiry_items_on_serasa_inquiry_id"
  end

  create_table "serasa_negative_data", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "serasa_fintech_report_id", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_fintech_report_id"], name: "index_serasa_negative_data_on_serasa_fintech_report_id", unique: true
  end

  create_table "serasa_negative_items", force: :cascade do |t|
    t.float "amount"
    t.string "city"
    t.string "contract_id"
    t.datetime "created_at", null: false
    t.string "creditor_name"
    t.string "federal_unit"
    t.string "legal_nature"
    t.string "legal_nature_id"
    t.date "occurrence_date"
    t.bigint "owner_id"
    t.string "owner_type"
    t.boolean "principal"
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_serasa_negative_items_on_owner"
  end

  create_table "serasa_notaries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "serasa_negative_data_id", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_negative_data_id"], name: "index_serasa_notaries_on_serasa_negative_data_id", unique: true
  end

  create_table "serasa_notary_items", force: :cascade do |t|
    t.float "amount"
    t.string "city"
    t.datetime "created_at", null: false
    t.string "federal_unit"
    t.date "occurrence_date"
    t.string "office_name"
    t.string "office_number"
    t.bigint "serasa_notary_id", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_notary_id"], name: "index_serasa_notary_items_on_serasa_notary_id"
  end

  create_table "serasa_pefins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "serasa_negative_data_id", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_negative_data_id"], name: "index_serasa_pefins_on_serasa_negative_data_id", unique: true
  end

  create_table "serasa_phones", force: :cascade do |t|
    t.string "area_code"
    t.datetime "created_at", null: false
    t.bigint "owner_id"
    t.string "owner_type"
    t.string "phone_number"
    t.string "region_code"
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_serasa_phones_on_owner", unique: true
  end

  create_table "serasa_refins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "serasa_negative_data_id", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_negative_data_id"], name: "index_serasa_refins_on_serasa_negative_data_id", unique: true
  end

  create_table "serasa_registrations", force: :cascade do |t|
    t.string "birth_date"
    t.string "consumer_name"
    t.datetime "created_at", null: false
    t.string "document_number"
    t.string "mother_name"
    t.bigint "serasa_fintech_report_id", null: false
    t.date "status_date"
    t.string "status_registration"
    t.datetime "updated_at", null: false
    t.index ["serasa_fintech_report_id"], name: "index_serasa_registrations_on_serasa_fintech_report_id", unique: true
  end

  create_table "serasa_scores", force: :cascade do |t|
    t.integer "code_message"
    t.datetime "created_at", null: false
    t.string "default_rate"
    t.string "message"
    t.string "range"
    t.integer "score"
    t.string "score_model"
    t.bigint "serasa_fintech_report_id", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_fintech_report_id"], name: "index_serasa_scores_on_serasa_fintech_report_id", unique: true
  end

  create_table "serasa_stolen_document_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "detailed_reason"
    t.string "document_number"
    t.string "document_type"
    t.datetime "inclusion_date"
    t.string "issuing_authority"
    t.date "occurrence_date"
    t.string "occurrence_state"
    t.bigint "serasa_stolen_document_id", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_stolen_document_id"], name: "idx_on_serasa_stolen_document_id_e5dbecfd0e"
  end

  create_table "serasa_stolen_documents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "serasa_fact_id", null: false
    t.datetime "updated_at", null: false
    t.index ["serasa_fact_id"], name: "index_serasa_stolen_documents_on_serasa_fact_id", unique: true
  end

  create_table "serasa_summaries", force: :cascade do |t|
    t.float "balance"
    t.integer "count"
    t.datetime "created_at", null: false
    t.bigint "owner_id"
    t.string "owner_type"
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_serasa_summaries_on_owner", unique: true
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

  add_foreign_key "analysis_item_steps", "analysis_items"
  add_foreign_key "analysis_item_steps", "analysis_steps"
  add_foreign_key "analysis_items", "analysis_items", column: "clone_of_id"
  add_foreign_key "analysis_items", "analysis_reports"
  add_foreign_key "analysis_predictions", "analysis_items"
  add_foreign_key "analysis_reports", "api_clients"
  add_foreign_key "answers", "options"
  add_foreign_key "answers", "users"
  add_foreign_key "api_webhook_credentials", "api_clients"
  add_foreign_key "api_webhook_events", "analysis_reports"
  add_foreign_key "api_webhook_events", "api_clients"
  add_foreign_key "api_webhook_events", "api_webhook_subscriptions"
  add_foreign_key "api_webhook_subscriptions", "api_webhook_credentials"
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
  add_foreign_key "options", "questions"
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
  add_foreign_key "questions", "researches"
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
  add_foreign_key "views", "users"
  add_foreign_key "views", "videos"
end
