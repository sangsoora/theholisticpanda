class Specialty < ApplicationRecord
  has_many :practitioner_specialties
  has_many :specialty_conditions
  has_many :practitioner, through: :practitioner_specialties
  has_many :conditions, through: :specialty_conditions
end
