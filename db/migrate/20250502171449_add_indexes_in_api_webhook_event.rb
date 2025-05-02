class AddIndexesInApiWebhookEvent < ActiveRecord::Migration[8.0]
  def change
    add_index :api_webhook_events, :event_type
    add_index :api_webhook_events, :event_id
    add_index :api_webhook_events, :status
    add_index :api_webhook_events, :callback_url
    add_index :api_webhook_events, :callback_id
  end
end
