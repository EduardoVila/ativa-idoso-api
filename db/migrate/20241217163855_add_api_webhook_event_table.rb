class AddApiWebhookEventTable < ActiveRecord::Migration[8.0]
  def change
    create_table :api_webhook_events, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :callback_url
      t.bigint :callback_id
      t.string :event_type
      t.uuid :event_id
      t.string :job_id
      t.integer :status
      t.jsonb :payload
      t.jsonb :response
      t.string :access_token
      t.references :api_client, type: :uuid, null: false, foreign_key: true, index: true
      t.timestamps
    end
  end
end
