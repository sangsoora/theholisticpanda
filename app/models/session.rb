class Session < ApplicationRecord
  belongs_to :user
  belongs_to :service
  delegate :practitioner, to: :service, allow_nil: true
  monetize :amount_cents
  validates_presence_of :link, :if => lambda { |o| o.service.service_type == 'Virtual' }
end
