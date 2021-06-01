class AddCouponIdToUserPromo < ActiveRecord::Migration[5.2]
  def change
    add_column :user_promos, :coupon_id, :string
  end
end
