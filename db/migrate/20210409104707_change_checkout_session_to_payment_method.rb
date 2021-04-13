class ChangeCheckoutSessionToPaymentMethod < ActiveRecord::Migration[5.2]
  def change
    rename_column :sessions, :checkout_session_id, :payment_method_id
  end
end
