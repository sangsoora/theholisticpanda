class PractitionerSpecialty < ApplicationRecord
  belongs_to :practitioner
  belongs_to :specialty
  validates_uniqueness_of :practitioner, scope: [:specialty]
  has_many :services, dependent: :destroy
end
