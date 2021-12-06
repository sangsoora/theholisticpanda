class AddFieldsToSessions < ActiveRecord::Migration[5.2]
  def change
    add_column :sessions, :user_checkout_reminder, :integer
    add_column :sessions, :practitioner_request_reminder, :integer
    add_column :sessions, :practitioner_charge_reminder, :integer
  end
end
