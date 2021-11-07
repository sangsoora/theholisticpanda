class AddFieldsToPractitioners < ActiveRecord::Migration[5.2]
  def change
    add_column :practitioners, :activated_at, :datetime
    add_column :practitioners, :setup_profile_reminder, :integer
  end
end
