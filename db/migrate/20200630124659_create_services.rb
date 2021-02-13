class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :name
      t.text :description
      t.string :service_type
      t.integer :duration
      t.boolean :active
      t.boolean :default_service
      t.references :practitioner_specialty, foreign_key: true

      t.timestamps
    end
  end
end
