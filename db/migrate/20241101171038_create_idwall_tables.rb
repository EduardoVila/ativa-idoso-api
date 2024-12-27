class CreateIdwallTables < ActiveRecord::Migration[8.0]
  def change
    create_table :idwall_reports do |t|
      t.string :number, null: false
      t.integer :status, default: 0
      t.string :raw_data
      t.references :analysis_item, type: :uuid, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :idwall_addresses do |t|
      t.string :main
      t.string :city
      t.string :state
      t.string :number
      t.string :zip_code
      t.string :street
      t.string :neighborhood
      t.string :people_at_address
      t.string :kind
      t.references :idwall_report, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :idwall_cpfs do |t|
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
      t.references :idwall_report, null: false, foreign_key: true, index: { unique: true }
      t.timestamps
    end

    create_table :idwall_related_people do |t|
      t.string :cpf
      t.string :name
      t.string :kind
      t.references :idwall_report, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :idwall_trials do |t|
      t.string :subject
      t.string :kind
      t.references :idwall_report, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :idwall_trial_parts do |t|
      t.string :cnpj
      t.string :cpf
      t.string :birth_date
      t.string :name
      t.string :rg
      t.string :gender
      t.string :kind
      t.string :title
      t.references :idwall_trial, null: false, foreign_key: true, index: true
      t.timestamps
    end
  end
end
