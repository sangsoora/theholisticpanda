class CreatePaymentMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_methods do |t|
      t.string :payment_method_id
      t.string :billing_country
      t.string :billing_state
      t.integer :last4
      t.boolean :default
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
