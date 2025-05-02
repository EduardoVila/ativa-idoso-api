class RemovePredictionInAnalysisItem < ActiveRecord::Migration[8.0]
  def change
    remove_column :analysis_items, :prediction, :integer
  end
end
