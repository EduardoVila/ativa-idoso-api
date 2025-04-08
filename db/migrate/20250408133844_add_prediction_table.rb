class AddPredictionTable < ActiveRecord::Migration[8.0]
  def change
    create_table :prediction_tokens do |t|
      t.string :access_token
      t.string :token_type
      t.integer :expires_in
      t.string :scope
      t.timestamps
    end
  end
end
