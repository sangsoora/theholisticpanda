class AddFieldsToSession < ActiveRecord::Migration[5.2]
  def change
    add_column :sessions, :free_session, :boolean
    add_column :sessions, :decline_reason, :string
  end
end
