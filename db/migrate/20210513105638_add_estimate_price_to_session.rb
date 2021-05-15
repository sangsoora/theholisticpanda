class AddEstimatePriceToSession < ActiveRecord::Migration[5.2]
  def change
    add_column :sessions, :estimate_price, :float
  end
end
