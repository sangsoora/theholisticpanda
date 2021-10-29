class AddCodeNameToEventCode < ActiveRecord::Migration[5.2]
  def change
    add_column :event_codes, :code_name, :string
  end
end
