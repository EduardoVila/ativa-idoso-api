class DropGuarantorTokensTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :guarantor_tokens, if_exists: true do |t|
      t.string :access_token
      t.string :token_type
      t.integer :expires_in
      t.string :scope
      t.timestamps
    end
  end
end


    # create_table :guarantor_tokens do |t|
    #   t.string :access_token
    #   t.string :token_type
    #   t.integer :expires_in
    #   t.string :scope
    #   t.timestamps
    # end