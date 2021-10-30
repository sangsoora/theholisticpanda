class ChangeFieldsInUserPromo < ActiveRecord::Migration[5.2]
  def change
    rename_column :user_promos, :condition_type, :type
    add_column :user_promos, :discount_on, :string
  end
end
