class AddStepsDataInAnalysisItem < ActiveRecord::Migration[8.0]
  def change
    add_column :analysis_items, :steps_data, :jsonb, default: {}, null: false
  end
end
