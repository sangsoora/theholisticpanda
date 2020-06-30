class Specialty < ApplicationRecord
  has_many :practitioner_specialties
  has_many :conditions
end
