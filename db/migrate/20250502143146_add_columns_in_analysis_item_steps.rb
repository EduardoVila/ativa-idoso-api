class AddColumnsInAnalysisItemSteps < ActiveRecord::Migration[8.0]
  def change
    add_column :analysis_item_steps, :started_at, :datetime
    add_column :analysis_item_steps, :finished_at, :datetime
    add_column :analysis_item_steps, :duration, :float
    add_column :analysis_item_steps, :execution_status, :integer
    add_column :analysis_item_steps, :result_summary, :jsonb, default: {}, null: false
  end
end
