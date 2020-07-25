class PractitionerLanguage < ApplicationRecord
  belongs_to :practitioner
  belongs_to :language
  validates_uniqueness_of :practitioner, scope: [:language]
end
