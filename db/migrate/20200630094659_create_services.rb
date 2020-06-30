class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :name
      t.string :description
      t.integer :price
      t.integer :duration
      t.references :practitioner_specialty, foreign_key: true

      t.timestamps
    end
  end
end
