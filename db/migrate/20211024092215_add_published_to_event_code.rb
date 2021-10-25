class AddPublishedToEventCode < ActiveRecord::Migration[5.2]
  def change
    add_column :event_codes, :published, :boolean, :default => false
  end
end
