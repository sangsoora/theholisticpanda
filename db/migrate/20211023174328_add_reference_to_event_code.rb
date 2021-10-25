class AddReferenceToEventCode < ActiveRecord::Migration[5.2]
  def change
    add_reference :event_codes, :event, foreign_key: true
  end
end
