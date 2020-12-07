class Specialty < ApplicationRecord
  has_many :practitioner_specialties
  has_many :practitioner, through: :practitioner_specialties
  belongs_to :specialty_category
end
