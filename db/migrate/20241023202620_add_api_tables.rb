class AddApiTables < ActiveRecord::Migration[8.0]
  def change
    create_table :api_clients do |t|
      t.string :client_id, null: false
      t.string :client_secret, null: false
      t.string :name
      t.string :description
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

    create_table :api_webhook_events do |t|
      t.string :callback_url
      t.bigint :callback_id
      t.string :event_type
      t.bigint :event_id
      t.uuid :job_id
      t.integer :status
      t.jsonb :payload
      t.jsonb :response
      t.integer :requester, null: false, default: 0
      t.index :callback_url
      t.index :callback_id
      t.index :status
      t.index :event_id
      t.index :requester
      t.references :api_client, null: false, foreign_key: true, index: true
      t.timestamps
    end
  end
end
