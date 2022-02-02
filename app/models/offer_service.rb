class OfferService < ApplicationRecord
  belongs_to :offer
  belongs_to :service
  has_one_attached :photo
  validates_uniqueness_of :service, scope: [:offer]
end
