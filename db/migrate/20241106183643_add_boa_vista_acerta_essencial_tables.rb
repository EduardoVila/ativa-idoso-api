class AddBoaVistaAcertaEssencialTables < ActiveRecord::Migration[8.0]
  def change
    create_table :boa_vista_acerta_essencials do |t|
      t.string :cpf, null: false
      t.integer :credit_type, null: false, default: 0
      t.string :raw_data
      t.references :consumer, polymorphic: true, type: :uuid, index: true
      t.timestamps
    end

    create_table :boa_vista_additional_informations do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :text
      t.string :origin
      t.string :fu_origin
      t.string :information_type
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: "index_boa_vista_additional_information_on_acerta_essencial_id",
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_debits do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :occurrence_type
      t.string :occurrence_date
      t.string :contract
      t.string :availability_date
      t.string :currency, default: '0'
      t.string :value
      t.string :condition
      t.string :informant
      t.string :segment
      t.string :informed_by_querent
      t.references :boa_vista_acerta_essencial, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_protested_titles do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :occurrence_type
      t.string :registry
      t.string :occurrence_date
      t.string :currency
      t.string :value
      t.string :city
      t.string :federative_unit
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_protested_titles_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_protested_title_summaries do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :total
      t.string :initial_period
      t.string :final_period
      t.string :currency
      t.string :accumulated_value
      t.string :federative_unit
      t.references :boa_vista_acerta_essencial, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_identifications do |t|
      t.string :register_size
      t.string :register
      t.string :document
      t.string :name
      t.string :mother_name
      t.string :birth_date
      t.string :rg_number
      t.string :emitting_organ
      t.string :rg_federative_unit
      t.string :rg_emitting_date
      t.string :consulted_gender
      t.string :birth_city
      t.string :marital_status
      t.string :dependent_number
      t.string :educational_level
      t.string :revenue_situation
      t.string :update_date
      t.string :cpf_zone
      t.string :voter_title
      t.string :death
      t.references :boa_vista_acerta_essencial, null: false, index:  {
        name: :index_boa_vista_identifications_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_debit_occurrences do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :total_debtor
      t.string :total_guarantor
      t.string :accumulated_value
      t.string :first_debit_date
      t.string :first_debit_value
      t.string :biggest_debit_date
      t.string :biggest_debit_value
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_boa_vista_debit_occurrences_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_locations do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :public_place_type
      t.string :public_place_name
      t.string :public_place_number
      t.string :complement
      t.string :neighborhood
      t.string :city
      t.string :federative_unit
      t.string :zip_code
      t.string :ddd_1
      t.string :phone_1
      t.string :ddd_2
      t.string :phone_2
      t.string :ddd_3
      t.string :phone_3
      t.references :boa_vista_acerta_essencial, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_previous_queries do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :occurrence_type
      t.string :date
      t.string :currency
      t.string :value
      t.string :informant
      t.string :product
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_previous_queries_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_cheque_additional_informations do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :document_type
      t.string :document_number
      t.string :text
      t.string :type_of_register
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: "index_boa_vista_cheque_additional_info_on_acerta_essencial_id",
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_current_account_historics do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :bank
      t.string :agency
      t.string :current_account
      t.string :document_type
      t.string :document_number
      t.string :consultation_date
      t.string :consultation_hour
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_boa_vista_current_account_historic_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_decisions do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :document_type
      t.string :document
      t.string :score
      t.string :approves
      t.string :text
      t.references :boa_vista_acerta_essencial, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_zip_code_confirmations do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :zip_code
      t.string :address
      t.string :neighborhood
      t.string :city
      t.string :federative_unit
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_zip_code_confirmations_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_documents_names do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :name
      t.string :birth_date
      t.string :document_type
      t.string :document_number
      t.string :document_2
      t.string :document_3
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_boa_vista_documents_names_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_list_of_returns_reported_by_ccfs do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :document_type
      t.string :document_number
      t.string :name
      t.string :bank
      t.string :agency
      t.string :reason_12
      t.string :last_occurrence_12_date
      t.string :reason_13
      t.string :last_occurrence_13_date
      t.string :reason_14
      t.string :last_occurrence_14_date
      t.string :reason_99
      t.string :last_occurrence_99_date
      t.string :bank_name
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_list_of_returns_reported_by_ccfs_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_returns_reported_by_users do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :document_type
      t.string :document
      t.string :bank
      t.string :agency
      t.string :current_account
      t.string :initial_cheque
      t.string :final_cheque
      t.string :reason
      t.string :point
      t.string :occurrence_date
      t.string :register_date
      t.string :currency
      t.string :value
      t.string :informant_code
      t.string :informant
      t.string :city
      t.string :federative_unit
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_returns_reported_by_users_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_cheques_stopped_for_reason21s do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :document_type
      t.string :document_number
      t.string :bank
      t.string :agency
      t.string :current_account
      t.string :initial_cheque
      t.string :final_cheque
      t.string :point
      t.string :occurrence_date
      t.string :availability_date
      t.string :currency
      t.string :value
      t.string :informant
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: "index_cheques_stopped_for_reason21_on_acerta_essencial_id",
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_historic_informed_cheques do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :document_type
      t.string :document_number
      t.string :bank
      t.string :agency
      t.string :current_account
      t.string :cheque
      t.string :consultation_date
      t.string :consultation_hour
      t.string :network
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_boa_vista_historic_informed_cheque_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_previous_cheque_consultations do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :document_type
      t.string :document_number
      t.string :consultation_type
      t.string :credit_date
      t.string :credit_hour
      t.string :currency
      t.string :value
      t.string :informant
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_previous_cheque_consultations_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_summary_of_returns_reported_by_users do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :document_type
      t.string :document_number
      t.string :total
      t.string :first_devolution_date
      t.string :last_devolution_date
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_summary_of_return_reported_by_user_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_score_rating_several_models do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :score_type
      t.string :score
      t.string :plan_name
      t.string :score_model
      t.string :score_name
      t.string :numeric_classification
      t.string :alphabetic_classification
      t.string :probability
      t.string :text
      t.string :code_kind_model
      t.string :kind_description
      t.string :text_2
      t.string :value
      t.string :message
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_score_rating_several_models_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_record_messages do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :record_reference
      t.string :text
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_record_messages_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_previous90_days_consultations do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :total
      t.string :year_1
      t.string :month_1
      t.string :total_1
      t.string :year_2
      t.string :month_2
      t.string :total_2
      t.string :year_3
      t.string :month_3
      t.string :total_3
      t.string :year_4
      t.string :month_4
      t.string :total_4
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_previous90_days_consultations_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_cheque_stoppeds do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :occurrence_type
      t.string :document_type
      t.string :document_number
      t.string :bank
      t.string :agency
      t.string :current_account
      t.string :cheque
      t.string :point
      t.string :occurrence_date
      t.string :availability_date
      t.string :informant
      t.string :indicator
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: "index_boa_vista_cheque_stopped_on_acerta_essencial_id",
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_summary_devolution_reported_by_ccfs do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :document_type
      t.string :document_number
      t.string :name
      t.string :names_total
      t.string :devolution_total
      t.string :reason_12
      t.string :reason_13
      t.string :reason_14
      t.string :reason_99
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_summary_devolution_reported_by_ccf_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_summary_previous_query_cheques do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :document_type
      t.string :document_number
      t.string :total
      t.string :value
      t.string :day
      t.string :day_value
      t.string :pre_dated
      t.string :pre_dated_value
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_summary_previous_query_cheques_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_phone_confirmations do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :area_code
      t.string :phone
      t.string :document_type
      t.string :document_number
      t.string :name
      t.string :neighborhood
      t.string :zip_code
      t.string :city
      t.string :federative_unit
      t.references :boa_vista_acerta_essencial, null: false, index: {
        name: :index_boa_vista_phone_confirmations_on_acerta_essencial_id
      }, foreign_key: true
      t.timestamps
    end

    create_table :boa_vista_bank_branch_phones_addresses do |t|
      t.string :register_size
      t.string :register_type
      t.string :register
      t.string :bank
      t.string :bank_name
      t.string :agency
      t.string :agency_name
      t.string :address
      t.string :neighborhood
      t.string :zip_code
      t.string :city
      t.string :federative_unit
      t.string :plaza
      t.string :area_code
      t.string :phone_1
      t.string :phone_2
      t.string :reserved
      t.references :boa_vista_acerta_essencial, null: false, index: true, foreign_key: true
      t.timestamps
    end
  end
end
