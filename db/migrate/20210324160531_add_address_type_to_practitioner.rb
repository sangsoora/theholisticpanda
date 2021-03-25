class AddAddressTypeToPractitioner < ActiveRecord::Migration[5.2]
  def change
    add_column :practitioners, :address_type, :string
  end
end
