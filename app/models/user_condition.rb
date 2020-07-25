class UserCondition < ApplicationRecord
  belongs_to :user
  belongs_to :condition
  validates_uniqueness_of :user, scope: [:condition]
end
