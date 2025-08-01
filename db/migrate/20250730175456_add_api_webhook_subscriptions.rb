class AddApiWebhookSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :api_webhook_subscriptions do |t|
      t.references :api_webhook_credential, null: false, index: true, foreign_key: true
      t.string :endpoint_url
      t.boolean :active, null: false, default: true
      t.integer :max_retries, null: false, default: 5
      t.string :name
      t.text :description
      t.timestamps
    end
  end
end
