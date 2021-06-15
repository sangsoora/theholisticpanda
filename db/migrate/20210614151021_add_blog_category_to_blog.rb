class AddBlogCategoryToBlog < ActiveRecord::Migration[5.2]
  def change
    add_reference :blogs, :blog_category, foreign_key: true
  end
end
