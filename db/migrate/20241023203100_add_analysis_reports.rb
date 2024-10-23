class AddAnalysisReports < ActiveRecord::Migration[7.2]
  def change
    create_table :analysis_reports, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :cpf
      t.integer :status
      t.float :fee
      t.boolean :approved
      t.integer :disapproval_situation
      t.references :api_client, type: :uuid, null: false, foreign_key: true
      t.timestamps
    end
  end
end
