class CreateSpecialtyConditions < ActiveRecord::Migration[5.2]
  def change
    create_table :specialty_conditions do |t|
      t.references :specialty, foreign_key: true
      t.references :condition, foreign_key: true

      t.timestamps
    end
  end
end
