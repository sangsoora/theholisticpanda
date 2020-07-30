class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions do |t|
      t.datetime :start_time
      t.integer :duration
      t.datetime :primary_time
      t.datetime :secondary_time
      t.datetime :tertiary_time
      t.monetize :amount, currency: { present: false }
      t.boolean :paid
      t.string :status
      t.references :user, foreign_key: true
      t.references :service, foreign_key: true
      t.timestamps
    end
  end
end
