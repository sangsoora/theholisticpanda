class AddPriceToServices < ActiveRecord::Migration[5.2]
  def change
    add_monetize :services, :price, currency: { present: false }
  end
end
