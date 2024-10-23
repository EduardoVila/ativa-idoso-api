class AddApiClients < ActiveRecord::Migration[7.2]
  def change
    create_table :api_clients, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :client_id
      t.string :client_secret
      t.timestamps
    end
  end
end
