class ChangeTypeInUserPromo < ActiveRecord::Migration[5.2]
  def change
    rename_column :user_promos, :type, :promo_type
  end
end
