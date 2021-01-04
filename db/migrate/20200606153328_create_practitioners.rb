class CreatePractitioners < ActiveRecord::Migration[5.2]
  def change
    create_table :practitioners do |t|
      t.string :title
      t.string :location
      t.string :address
      t.text :bio
      t.text :approach
      t.string :country_code
      t.string :experience
      t.string :video
      t.string :timezone
      t.boolean :insurance
      t.float :latitude
      t.float :longitude
      t.string :background_check_status
      t.boolean :background_check_consent
      t.string :background_check_id
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
