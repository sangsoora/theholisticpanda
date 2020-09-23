class CreatePractitionerSocialLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :practitioner_social_links do |t|
      t.string :url
      t.string :media_type
      t.references :practitioner, foreign_key: true

      t.timestamps
    end
  end
end
