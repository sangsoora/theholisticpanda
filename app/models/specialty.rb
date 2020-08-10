class Specialty < ApplicationRecord
  has_many :practitioner_specialties
  has_many :specialty_health_goals
  has_many :practitioner, through: :practitioner_specialties
  has_many :health_goals, through: :specialty_health_goals
end
