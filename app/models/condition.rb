class Condition < ApplicationRecord
  has_many :user_conditions
  has_many :specialty_conditions
end
