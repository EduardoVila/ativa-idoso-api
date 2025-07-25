class AddApiWebhookCredentials < ActiveRecord::Migration[8.0]
  def change
    create_table :api_webhook_credentials do |t|
      t.references :api_client, null: false, foreign_key: true, index: true
      t.string :client_id
      t.string :client_secret
      t.string :auth_url
      t.string :description

      t.timestamps
    end
  end
end
