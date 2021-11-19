class EventAttendee < ApplicationRecord
  belongs_to :event
  monetize :price_cents, allow_nil: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
