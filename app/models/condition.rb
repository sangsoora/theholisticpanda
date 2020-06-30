class Condition < ApplicationRecord
  belongs_to :specialty
  has_many :user_conditions
end
