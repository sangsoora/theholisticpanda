class CreatePractitioners < ActiveRecord::Migration[5.2]
  def change
    create_table :practitioners do |t|
      t.string :location
      t.string :address
      t.text :bio
      t.string :service_type
      t.string :working_days
      t.time :starting_hour
      t.time :ending_hour
      t.string :country_code
      t.string :experience
      t.string :certification
      t.string :video
      t.string :website
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
