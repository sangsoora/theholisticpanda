class AddInvitedUserIdToReferredUser < ActiveRecord::Migration[5.2]
  def change
    add_column :referred_users, :invited_user_id, :integer
  end
end
