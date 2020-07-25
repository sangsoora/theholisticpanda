class SpecialtyCondition < ApplicationRecord
  belongs_to :specialty
  belongs_to :condition
  validates_uniqueness_of :specialty, scope: [:condition]
end
