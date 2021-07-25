class AddTitleToPostAuthor < ActiveRecord::Migration[5.2]
  def change
    add_column :post_authors, :title, :string
  end
end
