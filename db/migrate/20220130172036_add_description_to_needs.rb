class AddDescriptionToNeeds < ActiveRecord::Migration[5.2]
  def change
    add_column :needs, :description, :text
  end
end
