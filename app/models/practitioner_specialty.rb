class PractitionerSpecialty < ApplicationRecord
  belongs_to :practitioner
  belongs_to :specialty
  has_many :services, dependent: :destroy
end
