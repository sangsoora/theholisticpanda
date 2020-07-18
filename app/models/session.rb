class Session < ApplicationRecord
  belongs_to :user
  belongs_to :service
  delegate :practitioner, to: :service, allow_nil: true
  monetize :amount_cents
end
