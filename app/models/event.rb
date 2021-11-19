class Event < ApplicationRecord
  belongs_to :user
  has_many :event_attendees, dependent: :destroy
  has_many :event_codes, dependent: :destroy
  delegate :practitioner, to: :user, allow_nil: true

  has_one_attached :photo

  validates :name, presence: true
  validates :description, presence: true
  validates :start_time, presence: true
  validates :duration, presence: true
end
