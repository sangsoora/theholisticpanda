class NeedService < ApplicationRecord
  belongs_to :need
  belongs_to :service
  validates_uniqueness_of :service, scope: [:need]
end
