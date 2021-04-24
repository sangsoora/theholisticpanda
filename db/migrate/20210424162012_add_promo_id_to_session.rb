class AddPromoIdToSession < ActiveRecord::Migration[5.2]
  def change
    add_column :sessions, :promo_id, :string
  end
end
