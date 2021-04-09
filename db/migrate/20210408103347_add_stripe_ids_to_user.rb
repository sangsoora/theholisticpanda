class AddStripeIdsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :setup_session_id, :string
    add_column :users, :tax_id, :string
  end
end
