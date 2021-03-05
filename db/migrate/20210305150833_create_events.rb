class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :start_time
      t.integer :duration
      t.string :link
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
