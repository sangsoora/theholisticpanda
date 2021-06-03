class Event < ApplicationRecord
  belongs_to :user
  has_many :event_attendees

  has_one_attached :photo
end
