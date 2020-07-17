class AddCheckoutSessionIdToSessions < ActiveRecord::Migration[5.2]
  def change
    add_column :sessions, :checkout_session_id, :string
  end
end
