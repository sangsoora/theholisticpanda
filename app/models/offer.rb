class Offer < ApplicationRecord
  has_many :offer_services, dependent: :destroy
end
