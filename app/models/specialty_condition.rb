class SpecialtyCondition < ApplicationRecord
  belongs_to :specialty
  belongs_to :condition
end
