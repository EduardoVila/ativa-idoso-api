class CreateVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :videos do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.integer :section, null: false
      t.integer :level, null: false

      t.timestamps
    end
  end
end
