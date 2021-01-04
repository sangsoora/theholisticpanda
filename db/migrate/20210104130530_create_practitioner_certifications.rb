class CreatePractitionerCertifications < ActiveRecord::Migration[5.2]
  def change
    create_table :practitioner_certifications do |t|
      t.string :certification_type
      t.string :name
      t.references :practitioner, foreign_key: true

      t.timestamps
    end
  end
end
