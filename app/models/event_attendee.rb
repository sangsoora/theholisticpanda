class EventAttendee < ApplicationRecord
  belongs_to :event
  monetize :price_cents

  def full_name
    "#{first_name} #{last_name}"
  end
end
