class AddDescriptionToPostCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :post_categories, :description, :string
  end
end
