class AddServiceIdToUserPromo < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_promos, :service, foreign_key: true
  end
end
