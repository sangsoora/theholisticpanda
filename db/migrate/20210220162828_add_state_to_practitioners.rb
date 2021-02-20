class AddStateToPractitioners < ActiveRecord::Migration[5.2]
  def change
    add_column :practitioners, :state, :string
  end
end
