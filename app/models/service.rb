class Service < ApplicationRecord
  belongs_to :practitioner_specialty
  has_many :sessions
  has_one :practitioner, through: :practitioner_specialty
  has_one :specialty, through: :practitioner_specialty
  has_many :specialty_conditions, through: :specialty
  has_many :conditions, through: :specialty_conditions
  monetize :price_cents
end
