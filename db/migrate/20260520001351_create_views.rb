class CreateViews < ActiveRecord::Migration[8.0]
  def change
    create_table :views do |t|
      t.references :user, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true
      t.boolean :watched_completely, default: false
      t.integer :percentage_watched, default: 0

      t.timestamps
    end
  end
end
