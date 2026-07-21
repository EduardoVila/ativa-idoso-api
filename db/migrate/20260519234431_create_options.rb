class CreateOptions < ActiveRecord::Migration[8.0]
  def change
    create_table :options do |t|
      t.string :description, null: false
      t.string :color, null: false
      t.string :icon, null: false
      t.text :other_options, array: true, default: []
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
