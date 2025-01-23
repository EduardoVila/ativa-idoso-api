class AddPublicKeyTable < ActiveRecord::Migration[8.0]
  def change
    create_table :public_keys, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :key, null: false
      t.string :issuer, null: false
      t.string :algorithm, null: false
      t.datetime :valid_from, null: false
      t.datetime :valid_to, null: false
      t.timestamps
    end
  end
end
