class RecreateEventAttendees < ActiveRecord::Migration[5.2]
  def change
    drop_table :event_attendees

    create_table :event_attendees do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :event_consent
      t.boolean :terms_consent
      t.boolean :newsletter
      t.string :checkout_session_id
      t.string :payment_status
      t.monetize :price, currency: { present: false }
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
