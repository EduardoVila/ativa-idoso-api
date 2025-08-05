class RemoveRequesterOfApiWebhookEvents < ActiveRecord::Migration[8.0]
  def change
    remove_column :api_webhook_events, :requester, :string
  end
end
