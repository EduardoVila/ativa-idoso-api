class RemoveColumnsInSerasaStolenDocuments < ActiveRecord::Migration[8.0]
  def change
    remove_column :serasa_stolen_documents, :occurrence_date, :date
    remove_column :serasa_stolen_documents, :inclusion_date, :datetime
    remove_column :serasa_stolen_documents, :document_type, :string
    remove_column :serasa_stolen_documents, :document_number, :string
    remove_column :serasa_stolen_documents, :issuing_authority, :string
    remove_column :serasa_stolen_documents, :detailed_reason, :string
    remove_column :serasa_stolen_documents, :occurrence_state, :string
  end
end
