class AddStripeAccountToPractitioner < ActiveRecord::Migration[5.2]
  def change
    add_column :practitioners, :stripe_account_id, :string
  end
end
