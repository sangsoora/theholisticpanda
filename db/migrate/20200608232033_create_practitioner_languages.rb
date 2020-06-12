class CreatePractitionerLanguages < ActiveRecord::Migration[5.2]
  def change
    create_table :practitioner_languages do |t|
      t.references :practitioner, foreign_key: true
      t.references :language, foreign_key: true

      t.timestamps
    end
  end
end
