class AddApiClients < ActiveRecord::Migration[7.2]
  def change
    create_table :api_clients, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :client_id
      t.string :client_secret
      t.timestamps
    end
  end
end
