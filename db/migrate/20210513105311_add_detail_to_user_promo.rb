class AddDetailToUserPromo < ActiveRecord::Migration[5.2]
  def change
    add_column :user_promos, :detail, :string
  end
end
