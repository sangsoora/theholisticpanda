class AddRegisteredToReferredUser < ActiveRecord::Migration[5.2]
  def change
    add_column :referred_users, :registered, :boolean, default: false
  end
end
