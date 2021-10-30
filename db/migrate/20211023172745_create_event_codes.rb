class CreateEventCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :event_codes do |t|
      t.string :name
      t.datetime :expires_at
      t.string :detail
      t.string :coupon_id
      t.string :promo_type
      t.string :discount_on
      t.references :service, foreign_key: true
      t.references :practitioner, foreign_key: true

      t.timestamps
    end
  end
end
