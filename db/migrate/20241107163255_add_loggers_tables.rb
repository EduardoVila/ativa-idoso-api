class AddLoggersTables < ActiveRecord::Migration[7.1]
  def change
    create_table :request_logs, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :method
      t.string :path
      t.string :params
      t.string :headers
      t.string :body
      t.string :options
      t.timestamps
    end

    create_table :response_logs, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :table, null: false
      t.string :table_pointer
      t.string :path, null: false
      t.string :body
      t.string :status, null: false
      t.string :method
      t.string :headers
      t.string :raw_data
      t.timestamps
    end
  end
end
