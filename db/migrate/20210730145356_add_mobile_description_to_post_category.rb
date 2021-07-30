class AddMobileDescriptionToPostCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :post_categories, :mobile_description, :string
  end
end
