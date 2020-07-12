class Condition < ApplicationRecord
  has_many :user_conditions
  has_many :specialty_conditions
  has_many :users, through: :user_conditions
  has_many :specialties, through: :specialty_conditions
  has_many :practitioner, through: :specialties
end
