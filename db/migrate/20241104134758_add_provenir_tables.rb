class AddProvenirTables < ActiveRecord::Migration[8.0]
  def change
    create_table :provenir_big_data_corps do |t|
      t.string :raw_data
      t.references :analysis_item, type: :uuid, null: false, index: { unique: true }, foreign_key: true
      t.timestamps
    end

    create_table :provenir_basic_data do |t|
      t.string :tax_id_number
      t.string :tax_id_country
      t.string :name
      t.string :gender
      t.integer :name_word_count
      t.integer :number_of_full_name_namesakes
      t.integer :name_uniqueness_score
      t.integer :first_name_uniqueness_score
      t.integer :first_and_last_name_uniqueness_score
      t.datetime :birth_date
      t.integer :age
      t.string :zodiac_sign
      t.string :chinese_sign
      t.string :birth_country
      t.string :mother_name
      t.string :father_name
      t.string :marital_status_data
      t.string :tax_id_status
      t.string :tax_id_origin
      t.string :tax_id_fiscal_region
      t.boolean :has_obit_indication
      t.datetime :tax_id_status_date
      t.datetime :tax_id_status_registration_date
      t.datetime :creation_date
      t.datetime :last_update_date
      t.references :provenir_big_data_corp, null: false, foreign_key: true, index: {
        unique: true,
        name: :index_provenir_basic_datum_big_data_corp_id
      }
      t.timestamps
    end

    create_table :provenir_alternative_id_numbers do |t|
      t.string :document_type
      t.string :document_number
      t.references :provenir_basic_datum, null: false, foreign_key: true, index: { name: :index_provenir_alternative_id_number_basic_datum_id }
      t.timestamps
    end

    create_table :provenir_extended_document_informations do |t|
      t.references :provenir_basic_datum, null: false, foreign_key: true, index: { name: :index_provenir_extended_document_information_basic_datum_id }
      t.timestamps
    end

    create_table :provenir_rgs do |t|
      t.string :number
      t.string :document_last4_digits
      t.datetime :creation_date
      t.datetime :last_update_date
      t.references :provenir_extended_document_information, null: false, foreign_key: true, index: {
        unique: true,
        name: :index_big_data_rg_extended_document_information_id
      }
      t.timestamps
    end

    create_table :provenir_sources do |t|
      t.string :state
      t.string :ENADE
      t.references :provenir_rg, null: false, foreign_key: true, index: {
        unique: true,
        name: :index_provenir_source_rg_id
      }
      t.timestamps
    end

    create_table :provenir_aliases do |t|
      t.string :common_name
      t.string :standardized_name
      t.references :provenir_basic_datum, null: false, foreign_key: true, index: { name: :index_provenir_alias_basic_datum_id }
      t.timestamps
    end

    create_table :provenir_extended_addresses do |t|
      t.integer :total_addresses
      t.integer :total_active_addresses
      t.integer :total_work_addresses
      t.integer :total_personal_addresses
      t.integer :total_unique_addresses
      t.integer :total_address_passages
      t.integer :total_bad_address_passages
      t.datetime :oldest_address_passage_date
      t.datetime :newest_address_passage_date
      t.references :provenir_big_data_corp, null: false, foreign_key: true, index: {
        unique: true,
        name: :index_provenir_extended_address_big_data_corp_id
      }
      t.timestamps
    end

    create_table :provenir_addresses do |t|
      t.string :typology
      t.string :title
      t.string :address_main
      t.string :number
      t.string :complement
      t.string :neighborhood
      t.string :zip_code
      t.string :city
      t.string :state
      t.string :country
      t.string :address_type
      t.string :address_currently_in_rf_site
      t.string :complement_type
      t.string :build_code
      t.string :building_code
      t.string :household_code
      t.integer :address_entity_age
      t.integer :address_entity_total_passages
      t.integer :address_entity_bad_passages
      t.integer :address_entity_crawling_passages
      t.integer :address_entity_validation_passages
      t.integer :address_entity_query_passages
      t.float :address_entity_month_average_passages
      t.integer :address_global_age
      t.integer :address_global_total_passages
      t.integer :address_global_bad_passages
      t.integer :address_global_crawling_passages
      t.integer :address_global_validation_passages
      t.integer :address_global_query_passages
      t.float :address_global_month_average_passages
      t.integer :address_number_of_entities
      t.integer :priority
      t.boolean :is_main_for_entity
      t.boolean :is_recent_for_entity
      t.boolean :is_main_for_other_entity
      t.boolean :is_recent_for_other_entity
      t.boolean :is_active
      t.boolean :is_ratified
      t.boolean :is_likely_from_accountant
      t.datetime :last_validation_date
      t.datetime :entity_first_passage_date
      t.datetime :entity_last_passage_date
      t.datetime :global_first_passage_date
      t.datetime :global_last_passage_date
      t.integer :last3_months_passages, default: 0
      t.integer :last6_months_passages, default: 0
      t.integer :last12_months_passages, default: 0
      t.integer :last16_months_passages, default: 0
      t.integer :match_rate, default: 0
      t.datetime :creation_date
      t.datetime :capture_date
      t.datetime :last_update_date
      t.boolean :has_opt_in
      t.float :latitude
      t.float :longitude
      t.references :provenir_extended_address, null: false, foreign_key: true, index: { name: :index_provenir_address_extended_address_id }
      t.timestamps
    end

    create_table :provenir_extended_phones do |t|
      t.integer :total_phones
      t.integer :total_active_phones
      t.integer :total_work_phones
      t.integer :total_personal_phones
      t.integer :total_unique_phones
      t.integer :total_phone_passages
      t.integer :total_bad_phone_passages
      t.integer :total_last3_months_passages
      t.integer :total_last6_months_passages
      t.integer :total_last12_months_passages
      t.integer :total_last16_months_passages, default: 0
      t.integer :total_last18_months_passages
      t.datetime :oldest_phone_passage_date
      t.datetime :newest_phone_passage_date
      t.references :provenir_big_data_corp, null: false, foreign_key: true, index: {
        unique: true,
        name: :index_provenir_extended_phone_big_data_corp_id
      }
      t.timestamps
    end

    create_table :provenir_phones do |t|
      t.string :number
      t.string :complement
      t.string :area_code
      t.string :neighborhood
      t.string :zip_code
      t.string :city
      t.string :state
      t.string :country
      t.string :phone_type
      t.string :address_currently_in_rf_site
      t.string :complement_type
      t.string :build_code
      t.string :building_code
      t.string :household_code
      t.string :address_entity_age
      t.string :country_code
      t.string :type_of_phone_plan, default: ''
      t.string :portability_history, default: ''
      t.string :validation_status, default: ''
      t.datetime :last_validation_date
      t.datetime :first_passage_date_for_entity
      t.datetime :last_passage_date_for_entity
      t.datetime :first_passage_date_global
      t.datetime :last_passage_date_global
      t.datetime :creation_date
      t.datetime :capture_date
      t.boolean :phone_currently_in_rf_site
      t.integer :phone_entity_total_passages
      t.integer :phone_entity_bad_passages
      t.integer :phone_entity_crawling_passages
      t.integer :phone_entity_validation_passages
      t.integer :phone_entity_query_passages
      t.float :phone_entity_month_average_passages
      t.integer :phone_global_age
      t.integer :phone_global_total_passages
      t.integer :phone_global_bad_passages
      t.integer :phone_global_crawling_passages
      t.integer :phone_global_validation_passages
      t.integer :phone_global_query_passages
      t.float :phone_global_month_average_passages
      t.integer :last3_months_passages
      t.integer :last6_months_passages
      t.integer :last12_months_passages
      t.integer :last16_months_passages, default: 0
      t.integer :last18_months_passages
      t.integer :phone_number_of_entities
      t.integer :phone_number_of_family_related_entities
      t.integer :phone_number_of_related_entities
      t.integer :priority
      t.boolean :is_main_for_entity
      t.boolean :is_recent_for_entity
      t.boolean :is_main_for_other_entity
      t.boolean :is_recent_for_other_entity
      t.boolean :is_active
      t.boolean :is_likely_from_accountant
      t.boolean :is_in_do_not_call_list
      t.boolean :has_opt_in, default: false
      t.string :current_carrier
      t.references :provenir_extended_phone, null: false, foreign_key: true, index: { name: :index_provenir_phone_extended_phone_id }
      t.timestamps
    end

    create_table :provenir_financial_data do |t|
      t.string :total_assets
      t.datetime :creation_date
      t.datetime :last_update_date
      t.references :provenir_big_data_corp, null: false, foreign_key: true, index: {
        unique: true,
        name: :index_provenir_financial_datum_big_data_corp_id
      }
      t.timestamps
    end

    create_table :provenir_tax_returns do |t|
      t.integer :year
      t.string :status
      t.string :bank
      t.string :branch
      t.string :batch
      t.boolean :is_vip_branch
      t.datetime :capture_date
      t.datetime :creation_date
      t.datetime :last_update_date
      t.references :provenir_financial_datum, null: false, foreign_key: true, index: { name: :index_provenir_tax_return_financial_datum_id }
      t.timestamps
    end

    create_table :provenir_income_estimates do |t|
      t.string :mte
      t.string :company_ownership
      t.string :ibge
      t.string :bigdata
      t.string :bigdata_v2
      t.references :provenir_financial_datum, null: false, foreign_key: true, index: {
        unique: true,
        name: :index_provenir_income_estimate_financial_datum_id
      }
      t.timestamps
    end

    create_table :provenir_financial_risks do |t|
      t.string :total_assets
      t.string :estimated_income_range
      t.boolean :is_currently_employed
      t.boolean :is_currently_owner
      t.datetime :last_occupation_start_date
      t.boolean :is_currently_on_collection
      t.integer :last365_days_collection_occurrences
      t.integer :current_consecutive_collection_months
      t.boolean :is_currently_receiving_assistance
      t.integer :financial_risk_score
      t.string :financial_risk_level
      t.references :provenir_big_data_corp, null: false, foreign_key: true, index: {
        unique: true,
        name: :index_provenir_financial_risk_big_data_corp_id
      }
      t.timestamps
    end

    create_table :provenir_processes do |t|
      t.integer :lawsuits_total
      t.integer :defendant_lawsuits_total
      t.integer :plaintiff_lawsuits_total
      t.references :provenir_big_data_corp, null: false, foreign_key: true, index: {
        unique: true,
        name: :index_provenir_process_big_data_corp_id
      }
      t.timestamps
    end

    create_table :provenir_lawsuits do |t|
      t.string :lawsuit_number
      t.string :lawsuit_type
      t.text :main_subject, limit: 1000
      t.string :court_name
      t.string :court_level
      t.string :court_type
      t.string :court_district
      t.string :judging_body
      t.string :state
      t.string :status
      t.string :lawsuit_host_service
      t.string :inferred_cnj_subject_name
      t.string :inferred_cnj_subject_number
      t.string :inferred_cnj_procedure_type_name
      t.string :inferred_broad_cnj_subject_name
      t.string :inferred_broad_cnj_subject_number
      t.integer :number_of_volumes
      t.integer :number_of_pages
      t.string :value
      t.datetime :res_judicata_date
      t.datetime :close_date
      t.datetime :redistribution_date
      t.datetime :publication_date
      t.datetime :notice_date
      t.datetime :last_movement_date
      t.datetime :capture_date
      t.datetime :last_update
      t.integer :number_of_parties
      t.integer :number_of_updates
      t.integer :law_suit_age
      t.float :average_number_of_updates_per_month
      t.string :reason_for_concealed_data
      t.references :provenir_process, null: false, foreign_key: true, index: { name: :index_provenir_lawsuit_process_id }
      t.timestamps
    end

    create_table :provenir_decisions do |t|
      t.text :decision_content, limit: 1000
      t.datetime :decision_date
      t.references :provenir_lawsuit, null: false, foreign_key: true, index: { name: :index_provenir_decision_lawsuit_id }
      t.timestamps
    end

    create_table :provenir_parties do |t|
      t.string :party_doc
      t.boolean :is_party_active
      t.string :name
      t.string :polarity
      t.string :party_type
      t.datetime :last_capture_date
      t.references :provenir_lawsuit, null: false, foreign_key: true, index: { name: :index_provenir_party_lawsuit_id }
      t.timestamps
    end

    create_table :provenir_party_details do |t|
      t.string :specific_type
      t.references :provenir_party, null: false, foreign_key: true, index: {
        unique: true,
        name: :index_provenir_party_detail_party_id
      }
      t.timestamps
    end

    create_table :provenir_petitions do |t|
      t.references :provenir_lawsuit, null: false, foreign_key: true, index: { name: :index_provenir_petition_lawsuit_id }
      t.timestamps
    end

    create_table :provenir_updates do |t|
      t.text :content, limit: 1000
      t.datetime :publish_date
      t.datetime :capture_date
      t.references :provenir_lawsuit, null: false, foreign_key: true, index: { name: :index_provenir_update_lawsuit_id }
      t.timestamps
    end

    create_table :provenir_related_people do |t|
      t.integer :total_relationships
      t.integer :total_relatives
      t.integer :total_neighbors
      t.integer :total_spouses
      t.integer :total_coworkers
      t.integer :total_household
      t.integer :total_partners
      t.integer :total_college_class
      t.references :provenir_big_data_corp, null: false, foreign_key: true, index: {
        unique: true,
        name: :index_provenir_related_person_big_data_corp_id
      }
      t.timestamps
    end

    create_table :provenir_personal_relationships do |t|
      t.string :related_entity_tax_id_number
      t.string :related_entity_tax_id_type
      t.string :related_entity_tax_id_country
      t.string :related_entity_name
      t.string :relationship_type
      t.string :relationship_level
      t.datetime :relationship_start_date
      t.datetime :relationship_end_date
      t.datetime :creation_date
      t.datetime :last_update_date
      t.references :provenir_related_person, null: false, foreign_key: true, index: { name: :index_provenir_personal_relationship_related_person_id }
      t.timestamps
    end

    create_table :provenir_collections do |t|
      t.boolean :is_currently_on_collection
      t.integer :last30_days_collection_occurrences
      t.integer :last90_days_collection_occurrences
      t.integer :last180_days_collection_occurrences
      t.integer :last365_days_collection_occurrences
      t.integer :last30_days_collection_origins
      t.integer :last90_days_collection_origins
      t.integer :last180_days_collection_origins
      t.integer :last365_days_collection_origins
      t.integer :total_collection_months
      t.integer :current_consecutive_collection_months
      t.integer :max_consecutive_collection_months
      t.datetime :first_collection_date
      t.datetime :last_collection_date
      t.integer :collection_occurrences
      t.integer :collection_origins
      t.references :provenir_big_data_corp, null: false, foreign_key: true, index: {
        unique: true,
        name: :index_provenir_collection_big_data_corp_id
      }
      t.timestamps
    end

    create_table :provenir_business_relationships do |t|
      t.integer :total_relationships
      t.integer :total_ownerships
      t.integer :total_employments
      t.integer :total_partners
      t.integer :total_clients
      t.integer :total_suppliers
      t.references :provenir_big_data_corp, null: false, foreign_key: true, index: {
        unique: true,
        name: :index_provenir_business_relationship_big_data_corp_id
      }
      t.timestamps
    end

    create_table :provenir_business_relationships_items do |t|
      t.string :related_entity_tax_id_number
      t.string :related_entity_tax_id_type
      t.string :related_entity_tax_id_country
      t.string :related_entity_name
      t.string :relationship_name
      t.string :relationship_type
      t.string :relationship_subtype
      t.string :relationship_level
      t.datetime :relationship_start_date
      t.datetime :relationship_end_date
      t.datetime :creation_date
      t.datetime :last_update_date
      t.string :additional_details
      t.references :provenir_business_relationship, null: false, foreign_key: true, index: { name: :index_provenir_bus_rel_items_business_relationship_id }
      t.timestamps
    end

    create_table :lawsuit_banned_keywords do |t|
      t.string :keyword
      t.integer :litigation_category, default: 0
      t.timestamps
    end
  end
end
