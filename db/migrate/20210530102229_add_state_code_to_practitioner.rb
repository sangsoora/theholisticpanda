class AddStateCodeToPractitioner < ActiveRecord::Migration[5.2]
  def change
    add_column :practitioners, :state_code, :string
  end
end
