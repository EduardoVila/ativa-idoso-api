class AddSerasaTables < ActiveRecord::Migration[8.0]
  def change
    create_table :serasa_fintech_reports do |t|
      t.string :raw_data
      t.references :analysis_item, type: :uuid, null: false, index:  { unique: true }, foreign_key: true
      t.timestamps
    end

    create_table :serasa_registrations do |t|
      t.string :document_number
      t.string :consumer_name
      t.string :mother_name
      t.string :birth_date
      t.string :status_registration
      t.date :status_date
      t.references :serasa_fintech_report, null: false, index: { unique: true }, foreign_key: true
      t.timestamps
    end

    create_table :serasa_negative_data do |t|
      t.references :serasa_fintech_report, null: false, index:  { unique: true }, foreign_key: true
      t.timestamps
    end

    create_table :serasa_scores do |t|
      t.integer :score
      t.string :score_model
      t.string :range
      t.string :default_rate
      t.integer :code_message
      t.string :message
      t.references :serasa_fintech_report, null: false, index: { unique: true }, foreign_key: true
      t.timestamps
    end

    create_table :serasa_facts do |t|
      t.references :serasa_fintech_report, null: false, index: { unique: true }, foreign_key: true
      t.timestamps
    end

    create_table :serasa_addresses do |t|
      t.string :address_line
      t.string :district
      t.string :zip_code
      t.string :country
      t.string :city
      t.string :state
      t.references :serasa_registration, null: false, index: { unique: true }, foreign_key: true
      t.timestamps
    end

    create_table :serasa_phones do |t|
      t.string :region_code
      t.string :area_code
      t.string :phone_number
      t.references :owner, polymorphic: true, index: { unique: true }
      t.timestamps
    end

    create_table :serasa_pefins do |t|
      t.references :serasa_negative_data, null: false, index: { unique: true }, foreign_key: true
      t.timestamps
    end

    create_table :serasa_refins do |t|
      t.references :serasa_negative_data, null: false, index: { unique: true }, foreign_key: true
      t.timestamps
    end

    create_table :serasa_notaries do |t|
      t.references :serasa_negative_data, null: false, index: { unique: true }, foreign_key: true
      t.timestamps
    end

    create_table :serasa_checks do |t|
      t.references :serasa_negative_data, null: false, index: { unique: true }, foreign_key: true
      t.timestamps
    end

    create_table :serasa_inquiries do |t|
      t.references :serasa_fact, null: false, index: { unique: true }, foreign_key: true
      t.timestamps
    end

    create_table :serasa_inquiry_items do |t|
      t.date :occurrence_date
      t.integer :days_quantity
      t.string :segment_description
      t.references :serasa_inquiry, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_stolen_documents do |t|
      t.date :occurrence_date
      t.datetime :inclusion_date
      t.string :document_type
      t.string :document_number
      t.string :issuing_authority
      t.string :detailed_reason
      t.string :occurrence_state
      t.references :serasa_fact, null: false, index: { unique: true }, foreign_key: true
      t.timestamps
    end

    create_table :serasa_stolen_document_items do |t|
      t.date :occurrence_date
      t.datetime :inclusion_date
      t.string :document_type
      t.string :document_number
      t.string :issuing_authority
      t.string :detailed_reason
      t.string :occurrence_state
      t.references :serasa_stolen_document, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_negative_items do |t|
      t.date :occurrence_date
      t.string :legal_nature_id
      t.string :legal_nature
      t.string :contract_id
      t.string :creditor_name
      t.float :amount
      t.string :city
      t.string :federal_unit
      t.boolean :principal
      t.references :owner, polymorphic: true, index: true
      t.timestamps
    end

    create_table :serasa_notary_items do |t|
      t.date :occurrence_date
      t.float :amount
      t.string :office_number
      t.string :office_name
      t.string :city
      t.string :federal_unit
      t.references :serasa_notary, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_check_items do |t|
      t.date :occurrence_date
      t.string :legal_square
      t.integer :bank_id
      t.string :bank_name
      t.integer :bank_agency_id
      t.integer :check_count
      t.string :city
      t.string :federal_unit
      t.string :check_number
      t.string :alinea
      t.references :serasa_check, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_summaries do |t|
      t.integer :count
      t.float :balance
      t.references :owner, polymorphic: true, index: { unique: true }
      t.timestamps
    end

    create_table :serasa_authentications do |t|
      t.string :access_token
      t.string :expires_in
      t.timestamps
    end
  end
end
