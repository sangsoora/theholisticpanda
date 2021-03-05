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
      t.string :checkout_session_id
      t.monetize :amount, currency: { present: false }
      t.string :payment_status
      t.boolean :agreement_consent
      t.string :agreement_status
      t.string :status
      t.string :state
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
