class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions do |t|
      t.datetime :start_time
      t.integer :duration
      t.string :session_type
      t.datetime :primary_time
      t.datetime :secondary_time
      t.datetime :tertiary_time
      t.text :message
      t.monetize :amount, currency: { present: false }
      t.boolean :paid
      t.string :link
      t.string :status
      t.text :cancel_reason
      t.integer :cancelled_user_id
      t.integer :free_practitioner_id
      t.references :user, foreign_key: true
      t.references :service, foreign_key: true
      t.timestamps
    end
  end
end
