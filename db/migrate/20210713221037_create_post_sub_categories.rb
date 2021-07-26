class CreatePostSubCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :post_sub_categories do |t|
      t.string :name
      t.string :description
      t.references :post_category, foreign_key: true

      t.timestamps
    end
  end
end
