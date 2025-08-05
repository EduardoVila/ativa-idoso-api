class AddReferenceOfApiWebhookSubscriptionsToApiWebhookEvents < ActiveRecord::Migration[8.0]
  def change
    add_reference :api_webhook_events, :api_webhook_subscription, foreign_key: true, null: true, index: true
  end
end
