class AddRequesterInApiWebhookEvent < ActiveRecord::Migration[8.0]
  def change
    add_column :api_webhook_events, :requester, :integer, default: 0
    add_index :api_webhook_events, :requester
  end
end
