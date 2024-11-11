class AddAnalysisTables < ActiveRecord::Migration[7.2]
  def change
    create_table :analysis_reports, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :cpfs, array: true
      t.integer :status
      t.float :fee
      t.boolean :approved
      t.integer :disapproval_situation
      t.references :api_client, type: :uuid, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :analysis_items, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :name
      t.string :cpf
      t.integer :status, default: 0
      t.integer :error_status, default: 0
      t.integer :prediction
      t.integer :payment_situation, default: 0
      t.integer :disapproval_situation
      t.jsonb :features, default: {}
      t.references :clone_of, type: :uuid, foreign_key: { to_table: :analysis_items }, index: true
      t.references :analysis_report, type: :uuid, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :analysis_steps, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :name
      t.integer :command_class
      t.integer :index_order
      t.boolean :enabled, default: true
      t.timestamps
    end

    create_table :analysis_item_steps, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.references :analysis_item, type: :uuid, null: false, foreign_key: true, index: true
      t.references :analysis_step, type: :uuid, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :analysis_predictions, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :cpf
      t.boolean :approved
      t.float :fee
      t.string :label
      t.jsonb :input_data
      t.references :analysis_item, type: :uuid, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :analysis_tokens, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :access_token
      t.string :token_type
      t.integer :expires_in
      t.string :scope
      t.timestamps
    end
  end
end
