class CreateWorkingHours < ActiveRecord::Migration[5.2]
  def change
    create_table :working_hours do |t|
      t.integer :day
      t.time :opens
      t.time :closes
      t.references :practitioner, foreign_key: true

      t.timestamps
    end
  end
end
