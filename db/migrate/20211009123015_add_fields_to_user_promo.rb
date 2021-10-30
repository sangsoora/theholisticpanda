class AddFieldsToUserPromo < ActiveRecord::Migration[5.2]
  def change
    add_reference :user_promos, :practitioner, foreign_key: true
    add_column :user_promos, :condition_type, :string
  end
end
