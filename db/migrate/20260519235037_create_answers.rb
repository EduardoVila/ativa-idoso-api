class CreateAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :answers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :option, null: false, foreign_key: true
      t.string :complement

      t.timestamps
    end
  end
end
