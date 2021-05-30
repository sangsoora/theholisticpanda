class Session < ApplicationRecord
  belongs_to :user
  belongs_to :service
  belongs_to :free_practitioner, foreign_key: :free_practitioner_id, class_name: :Practitioner, optional: true
  has_one :review
  belongs_to :cancelled_user, class_name: :User, optional: true
  delegate :practitioner, to: :service, allow_nil: true
  monetize :amount_cents
  monetize :discount_price_cents
  monetize :tax_price_cents
  monetize :estimate_price_cents
  # validates_presence_of :link, :if => lambda { |o| o.service.service_type == 'Virtual' }
end
