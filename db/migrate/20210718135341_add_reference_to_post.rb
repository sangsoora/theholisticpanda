class AddReferenceToPost < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :author
    add_reference :posts, :post_author, foreign_key: true
  end
end
