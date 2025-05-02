class AddPredictionModelNameInAnalysisReport < ActiveRecord::Migration[8.0]
  def change
    add_column :analysis_reports, :prediction_model_name, :string, default: nil
    add_index :analysis_reports, :prediction_model_name
  end
end
