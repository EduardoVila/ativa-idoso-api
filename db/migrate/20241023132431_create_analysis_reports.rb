class CreateAnalysisReports < ActiveRecord::Migration[7.2]
  def change
    create_table :analysis_reports do |t|
      t.string :name

      t.timestamps
    end
  end
end
