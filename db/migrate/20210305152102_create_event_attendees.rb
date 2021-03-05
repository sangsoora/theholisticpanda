class CreateEventAttendees < ActiveRecord::Migration[5.2]
  def change
    create_table :event_attendees do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :event_consent
      t.boolean :newsletter
      t.references :user, foreign_key: true
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
