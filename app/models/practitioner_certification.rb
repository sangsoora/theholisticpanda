class PractitionerCertification < ApplicationRecord
  belongs_to :practitioner

  $certification_types = ['Education', 'Certification']
end
