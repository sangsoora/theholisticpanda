class Session < ApplicationRecord
  belongs_to :user
  belongs_to :service
  has_one :review
  belongs_to :cancelled_user, class_name: "User", optional: true
  delegate :practitioner, to: :service, allow_nil: true
  monetize :amount_cents
  # validates_presence_of :link, :if => lambda { |o| o.service.service_type == 'Virtual' }
end
