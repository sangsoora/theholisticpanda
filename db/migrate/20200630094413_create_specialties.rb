class CreateSpecialties < ActiveRecord::Migration[5.2]
  def change
    create_table :specialties do |t|
      t.string :name
      t.text :description
      t.references :specialty_category, foreign_key: true

      t.timestamps
    end
  end
end
