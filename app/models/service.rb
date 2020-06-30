class Service < ApplicationRecord
  belongs_to :practitioner_specialty
  has_many :sessions
end
