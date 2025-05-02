class RemoveAccessTokenInApiWebhookEvents < ActiveRecord::Migration[8.0]
  def change
    remove_column :api_webhook_events, :access_token, :string
  end
end
