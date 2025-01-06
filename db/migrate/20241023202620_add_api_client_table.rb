class AddApiClientTable < ActiveRecord::Migration[8.0]
  def change
    create_table :api_clients, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :client_id, null: false
      t.string :client_secret, null: false
      t.text :validators, array: true, default: [
        "blocked_negativity_validator",
        "exceeded_debits_validator",
        "protested_titles_validator",
        "provenir_has_obit_indication_validator",
        "provenir_family_holding_validator",
        "provenir_process_validator",
        "provenir_age_and_income_validator"
      ]
      t.timestamps
    end
  end
end
