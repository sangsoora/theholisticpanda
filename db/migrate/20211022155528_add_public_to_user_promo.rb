class AddPublicToUserPromo < ActiveRecord::Migration[5.2]
  def change
    add_column :user_promos, :public, :boolean
  end
end
