class AddMinutesToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :minutes, :integer
  end
end
