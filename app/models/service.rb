class Service < ApplicationRecord
  belongs_to :practitioner_specialty
  has_many :sessions
  delegate :practitioner, to: :practitioner_specialty, allow_nil: true
end
