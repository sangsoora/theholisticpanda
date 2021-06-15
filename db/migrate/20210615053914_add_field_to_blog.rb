class AddFieldToBlog < ActiveRecord::Migration[5.2]
  def change
    add_column :blogs, :short_title, :string
    add_column :blogs, :published, :boolean
  end
end
