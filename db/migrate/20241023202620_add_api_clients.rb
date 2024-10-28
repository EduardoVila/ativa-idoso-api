class AddApiClients < ActiveRecord::Migration[7.2]
  def change
    create_table :api_clients, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :client_id, null: false
      t.string :client_secret, null: false
      t.timestamps
    end
  end
end
