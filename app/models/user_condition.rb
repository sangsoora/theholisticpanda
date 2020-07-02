class UserCondition < ApplicationRecord
  belongs_to :user
  belongs_to :condition
end
