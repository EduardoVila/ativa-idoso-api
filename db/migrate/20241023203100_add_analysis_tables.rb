class AddAnalysisTables < ActiveRecord::Migration[8.0]
  def change
    create_table :analysis_reports do |t|
      t.string :cpfs, array: true
      t.integer :status
      t.float :fee
      t.boolean :approved
      t.integer :disapproval_situation
      t.string :payload
      t.string :prediction_model_name
      t.references :api_client, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :analysis_items do |t|
      t.string :name
      t.string :cpf
      t.integer :status, default: 0
      t.integer :error_status, default: 0
      t.integer :disapproval_situation
      t.jsonb :features, default: {}
      t.references :clone_of, foreign_key: { to_table: :analysis_items }, index: true
      t.references :analysis_report, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :analysis_steps do |t|
      t.string :name
      t.string :command_class
      t.integer :index_order
      t.boolean :enabled, default: true
      t.timestamps
    end

    create_table :analysis_item_steps do |t|
      t.references :analysis_item, null: false, foreign_key: true, index: true
      t.references :analysis_step, null: false, foreign_key: true, index: true
      t.timestamps
    end

    create_table :analysis_predictions do |t|
      t.string :cpf
      t.boolean :approved
      t.float :fee
      t.string :label
      t.jsonb :input_data
      t.string :raw_data
      t.references :analysis_item, null: false, foreign_key: true, index: true
      t.timestamps
    end
  end
end
