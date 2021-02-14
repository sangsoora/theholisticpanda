class PractitionerCertification < ApplicationRecord
  belongs_to :practitioner
  validates :certification_type, presence: true
  $certification_types = ['Education', 'Certification']
end
