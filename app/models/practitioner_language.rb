class PractitionerLanguage < ApplicationRecord
  belongs_to :practitioner
  belongs_to :language
end
