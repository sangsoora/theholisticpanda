class Language < ApplicationRecord
  has_many :practitioner_languages
  has_many :practitioner, through: :practitioner_languages
end
