class CreatePractitionerSpecialties < ActiveRecord::Migration[5.2]
  def change
    create_table :practitioner_specialties do |t|
      t.references :practitioner, foreign_key: true
      t.references :specialty, foreign_key: true

      t.timestamps
    end
  end
end
