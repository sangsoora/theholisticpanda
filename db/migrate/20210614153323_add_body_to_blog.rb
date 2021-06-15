class AddBodyToBlog < ActiveRecord::Migration[5.2]
  def change
    add_column :blogs, :body, :text
  end
end
