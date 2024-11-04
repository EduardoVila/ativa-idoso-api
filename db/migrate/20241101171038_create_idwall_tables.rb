class CreateIdwallTables < ActiveRecord::Migration[7.2]
  def change
    create_table :idwall_reports, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :number
      t.integer :status
      t.string :raw_data
      t.references :analysis_item, type: :uuid, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :idwall_addresses, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :main
      t.string :city
      t.string :state
      t.string :number
      t.string :zip_code
      t.string :street
      t.string :neighborhood
      t.string :people_at_address
      t.string :kind
      t.references :idwall_report, type: :uuid, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :idwall_cpfs, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :gender
      t.string :number
      t.string :birth_date
      t.string :source
      t.string :name
      t.string :income
      t.string :income_tax_situation
      t.string :cpf_cadastral_situation
      t.string :cpf_subscription_date
      t.string :cpf_verifying_digit
      t.string :year_of_death
      t.string :social_name
      t.references :idwall_report, type: :uuid, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :idwall_related_people, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :cpf
      t.string :name
      t.string :kind
      t.references :idwall_report, type: :uuid, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :idwall_trials, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :subject
      t.string :kind
      t.references :idwall_report, type: :uuid, null: false, foreign_key: true, index: true
      t.timestamps
    end
    
    create_table :idwall_trial_parts, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :cnpj
      t.string :cpf
      t.string :birth_date
      t.string :name
      t.string :rg
      t.string :gender
      t.string :kind
      t.string :title
      t.references :idwall_trial, type: :uuid, null: false, foreign_key: true, index: true
      t.timestamps
    end
  end
end
