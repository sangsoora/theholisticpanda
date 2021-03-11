class AddCropSettingToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :crop_setting, :text
  end
end
