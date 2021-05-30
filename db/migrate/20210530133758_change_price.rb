class ChangePrice < ActiveRecord::Migration[5.2]
  def change
    remove_column :sessions, :estimate_price
    add_monetize :sessions, :discount_price, currency: { present: false }
    add_monetize :sessions, :tax_price, currency: { present: false }
    add_monetize :sessions, :estimate_price, currency: { present: false }
  end
end
