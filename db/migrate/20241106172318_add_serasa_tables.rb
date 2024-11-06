class AddSerasaTables < ActiveRecord::Migration[7.1]
  def change
    create_table :serasa_fintech_reports, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :raw_data
      t.references :analysis_item, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_registrations, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :document_number
      t.string :consumer_name
      t.string :mother_name
      t.string :birth_date
      t.string :status_registration
      t.date :status_date
      t.references :serasa_fintech_report, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_negative_data, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.references :serasa_fintech_report, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_scores, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.integer :score
      t.string :score_model
      t.string :range
      t.string :default_rate
      t.integer :code_message
      t.string :message
      t.references :serasa_fintech_report, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_facts, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.references :serasa_fintech_report, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_addresses, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :address_line
      t.string :district
      t.string :zip_code
      t.string :country
      t.string :city
      t.string :state
      t.references :serasa_registration, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_phones, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :region_code
      t.string :area_code
      t.string :phone_number
      t.references :owner, polymorphic: true, type: :uuid, index: true
      t.timestamps
    end

    create_table :serasa_pefins, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.references :serasa_negative_data, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_refins, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.references :serasa_negative_data, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_notaries, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.references :serasa_negative_data, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_checks, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.references :serasa_negative_data, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_inquiries, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.references :serasa_fact, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_inquiry_items, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.date :occurrence_date
      t.integer :days_quantity
      t.string :segment_description
      t.references :serasa_inquiry, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_stolen_documents, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.date :occurrence_date
      t.datetime :inclusion_date
      t.string :document_type
      t.string :document_number
      t.string :issuing_authority
      t.string :detailed_reason
      t.string :occurrence_state
      t.references :serasa_fact, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_stolen_document_items, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.date :occurrence_date
      t.datetime :inclusion_date
      t.string :document_type
      t.string :document_number
      t.string :issuing_authority
      t.string :detailed_reason
      t.string :occurrence_state
      t.references :serasa_stolen_document, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_negative_items, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.date :occurrence_date
      t.string :legal_nature_id
      t.string :legal_nature
      t.string :contract_id
      t.string :creditor_name
      t.float :amount
      t.string :city
      t.string :federal_unit
      t.boolean :principal
      t.references :owner, polymorphic: true, type: :uuid, index: true
      t.timestamps
    end

    create_table :serasa_notary_items, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.date :occurrence_date
      t.float :amount
      t.string :office_number
      t.string :office_name
      t.string :city
      t.string :federal_unit
      t.references :serasa_notary, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_check_items, id: :uuid, default: 'uuid_generate_v4()' do |t|
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
      t.references :serasa_check, type: :uuid, null: false, index: true, foreign_key: true
      t.timestamps
    end

    create_table :serasa_summaries, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.integer :count
      t.float :balance
      t.references :owner, polymorphic: true, type: :uuid, index: true
      t.timestamps
    end

    create_table :serasa_authentications, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :access_token
      t.string :expires_in
      t.timestamps
    end
  end
end
