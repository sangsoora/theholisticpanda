class ChangeReferenceToPostSubCategory < ActiveRecord::Migration[5.2]
  def change
    remove_reference :posts, :post_category, foreign_key: true
    add_reference :posts, :post_sub_category, foreign_key: true
  end
end
