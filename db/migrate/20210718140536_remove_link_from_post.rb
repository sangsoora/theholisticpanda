class RemoveLinkFromPost < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :link
  end
end
