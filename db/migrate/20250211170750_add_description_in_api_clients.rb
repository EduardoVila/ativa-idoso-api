class AddDescriptionInApiClients < ActiveRecord::Migration[8.0]
  def change
    add_column :api_clients, :description, :string
  end
end
