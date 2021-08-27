class EventAttendee < ApplicationRecord
  belongs_to :event
  monetize :price_cents, allow_nil: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
