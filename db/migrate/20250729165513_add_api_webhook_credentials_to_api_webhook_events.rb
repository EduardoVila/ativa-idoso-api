class AddApiWebhookCredentialsToApiWebhookEvents < ActiveRecord::Migration[8.0]
  def change
    add_reference :api_webhook_events, :api_webhook_credential, foreign_key: { to_table: :api_webhook_credentials }
  end
end
