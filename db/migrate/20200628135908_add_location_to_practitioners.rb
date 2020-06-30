class AddLocationToPractitioners < ActiveRecord::Migration[5.2]
  def change
    add_column :practitioners, :location, :string
  end
end
