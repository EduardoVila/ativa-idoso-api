# frozen_string_literal: true

class AddAnonymousUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :device_id, :string
    add_column :users, :anonymous, :boolean, null: false, default: false

    change_column_null :users, :cpf, true

    remove_index :users, name: 'index_users_on_cpf'
    add_index :users, :cpf, unique: true, where: 'cpf IS NOT NULL'
    add_index :users, :device_id, unique: true, where: 'device_id IS NOT NULL'
  end

  def down
    remove_index :users, column: :device_id
    remove_index :users, name: 'index_users_on_cpf'
    add_index :users, :cpf, unique: true

    change_column_null :users, :cpf, false
    remove_column :users, :anonymous
    remove_column :users, :device_id
  end
end
