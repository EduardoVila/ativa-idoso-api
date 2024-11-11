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

ActiveRecord::Schema[7.2].define(version: 2024_11_04_134758) do
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
    t.jsonb "features", default: {}
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

  create_table "lawsuit_banned_keywords", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "keyword"
    t.integer "litigation_category", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "provenir_addresses", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.uuid "provenir_extended_address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_extended_address_id"], name: "index_provenir_address_extended_address_id"
  end

  create_table "provenir_aliases", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "common_name"
    t.string "standardized_name"
    t.uuid "provenir_basic_datum_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_basic_datum_id"], name: "index_provenir_alias_basic_datum_id"
  end

  create_table "provenir_alternative_id_numbers", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "document_type"
    t.string "document_number"
    t.uuid "provenir_basic_datum_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_basic_datum_id"], name: "index_provenir_alternative_id_number_basic_datum_id"
  end

  create_table "provenir_basic_data", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.uuid "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_basic_datum_big_data_corp_id"
  end

  create_table "provenir_big_data_corps", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "raw_data"
    t.uuid "analysis_item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["analysis_item_id"], name: "index_provenir_big_data_corps_on_analysis_item_id"
  end

  create_table "provenir_business_relationships", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "total_relationships"
    t.integer "total_ownerships"
    t.integer "total_employments"
    t.integer "total_partners"
    t.integer "total_clients"
    t.integer "total_suppliers"
    t.uuid "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_business_relationship_big_data_corp_id"
  end

  create_table "provenir_business_relationships_items", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.uuid "provenir_business_relationship_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_business_relationship_id"], name: "index_provenir_bus_rel_items_business_relationship_id"
  end

  create_table "provenir_collections", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.uuid "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_collection_big_data_corp_id"
  end

  create_table "provenir_decisions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.text "decision_content"
    t.datetime "decision_date"
    t.uuid "provenir_lawsuit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_lawsuit_id"], name: "index_provenir_decision_lawsuit_id"
  end

  create_table "provenir_extended_addresses", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "total_addresses"
    t.integer "total_active_addresses"
    t.integer "total_work_addresses"
    t.integer "total_personal_addresses"
    t.integer "total_unique_addresses"
    t.integer "total_address_passages"
    t.integer "total_bad_address_passages"
    t.datetime "oldest_address_passage_date"
    t.datetime "newest_address_passage_date"
    t.uuid "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_extended_address_big_data_corp_id"
  end

  create_table "provenir_extended_document_informations", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "provenir_basic_datum_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_basic_datum_id"], name: "index_provenir_extended_document_information_basic_datum_id"
  end

  create_table "provenir_extended_phones", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.uuid "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_extended_phone_big_data_corp_id"
  end

  create_table "provenir_financial_data", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "total_assets"
    t.datetime "creation_date"
    t.datetime "last_update_date"
    t.uuid "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_financial_datum_big_data_corp_id"
  end

  create_table "provenir_financial_risks", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.uuid "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_financial_risk_big_data_corp_id"
  end

  create_table "provenir_income_estimates", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "mte"
    t.string "company_ownership"
    t.string "ibge"
    t.string "bigdata"
    t.string "bigdata_v2"
    t.uuid "provenir_financial_datum_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_financial_datum_id"], name: "index_provenir_income_estimate_financial_datum_id"
  end

  create_table "provenir_lawsuits", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.uuid "provenir_process_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_process_id"], name: "index_provenir_lawsuit_process_id"
  end

  create_table "provenir_parties", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "party_doc"
    t.boolean "is_party_active"
    t.string "name"
    t.string "polarity"
    t.string "party_type"
    t.datetime "last_capture_date"
    t.uuid "provenir_lawsuit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_lawsuit_id"], name: "index_provenir_party_lawsuit_id"
  end

  create_table "provenir_party_details", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "specific_type"
    t.uuid "provenir_party_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_party_id"], name: "index_provenir_party_detail_party_id"
  end

  create_table "provenir_personal_relationships", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.uuid "provenir_related_person_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_related_person_id"], name: "index_provenir_personal_relationship_related_person_id"
  end

  create_table "provenir_petitions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "provenir_lawsuit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_lawsuit_id"], name: "index_provenir_petition_lawsuit_id"
  end

  create_table "provenir_phones", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.uuid "provenir_extended_phone_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_extended_phone_id"], name: "index_provenir_phone_extended_phone_id"
  end

  create_table "provenir_processes", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "lawsuits_total"
    t.integer "defendant_lawsuits_total"
    t.integer "plaintiff_lawsuits_total"
    t.uuid "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_process_big_data_corp_id"
  end

  create_table "provenir_related_people", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "total_relationships"
    t.integer "total_relatives"
    t.integer "total_neighbors"
    t.integer "total_spouses"
    t.integer "total_coworkers"
    t.integer "total_household"
    t.integer "total_partners"
    t.integer "total_college_class"
    t.uuid "provenir_big_data_corp_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_big_data_corp_id"], name: "index_provenir_related_person_big_data_corp_id"
  end

  create_table "provenir_rgs", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "number"
    t.string "document_last4_digits"
    t.datetime "creation_date"
    t.datetime "last_update_date"
    t.uuid "provenir_extended_document_information_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_extended_document_information_id"], name: "index_big_data_rg_extended_document_information_id"
  end

  create_table "provenir_sources", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "state"
    t.string "ENADE"
    t.uuid "provenir_rg_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_rg_id"], name: "index_provenir_source_rg_id"
  end

  create_table "provenir_tax_returns", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "year"
    t.string "status"
    t.string "bank"
    t.string "branch"
    t.string "batch"
    t.boolean "is_vip_branch"
    t.datetime "capture_date"
    t.datetime "creation_date"
    t.datetime "last_update_date"
    t.uuid "provenir_financial_datum_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_financial_datum_id"], name: "index_provenir_tax_return_financial_datum_id"
  end

  create_table "provenir_updates", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.text "content"
    t.datetime "publish_date"
    t.datetime "capture_date"
    t.uuid "provenir_lawsuit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provenir_lawsuit_id"], name: "index_provenir_update_lawsuit_id"
  end

  add_foreign_key "analysis_item_steps", "analysis_items"
  add_foreign_key "analysis_item_steps", "analysis_steps"
  add_foreign_key "analysis_items", "analysis_items", column: "clone_of_id"
  add_foreign_key "analysis_items", "analysis_reports"
  add_foreign_key "analysis_predictions", "analysis_items"
  add_foreign_key "analysis_reports", "api_clients"
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
end
