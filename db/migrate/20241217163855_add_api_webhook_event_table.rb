class AddApiWebhookEventTable < ActiveRecord::Migration[8.0]
  def change
    create_table :api_webhook_events do |t|
      t.string :callback_url
      t.bigint :callback_id
      t.string :event_type
      t.bigint :event_id
      t.uuid :job_id
      t.integer :status
      t.jsonb :payload
      t.jsonb :response
      t.string :access_token
      t.references :api_client, null: false, foreign_key: true, index: true
      t.timestamps
    end
  end
end
