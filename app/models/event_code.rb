class EventCode < ApplicationRecord
  belongs_to :service, optional: true
  belongs_to :practitioner, optional: true
  belongs_to :event

  validates :name, presence: true
  validates :expires_at, presence: true
  validates :promo_type, presence: true
  validates :discount_on, presence: true
end
