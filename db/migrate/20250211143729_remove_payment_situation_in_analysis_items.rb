class RemovePaymentSituationInAnalysisItems < ActiveRecord::Migration[8.0]
  def change
    remove_column :analysis_items, :payment_situation, :integer
  end
end
