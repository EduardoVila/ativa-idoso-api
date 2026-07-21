class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.string :description, null: false
      t.references :research, null: false, foreign_key: true

      t.timestamps
    end
  end
end
