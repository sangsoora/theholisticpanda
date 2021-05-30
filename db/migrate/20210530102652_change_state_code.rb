class ChangeStateCode < ActiveRecord::Migration[5.2]
  def change
    remove_column :practitioners, :state_code
    rename_column :practitioners, :state, :state_code
  end
end
