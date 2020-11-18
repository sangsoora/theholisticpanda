class AddAdminToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin, :boolean, default: false
    add_column :users, :terms, :boolean, default: false
    add_column :users, :newsletter, :boolean, default: false
    add_column :users, :timezone, :string
  end
end
