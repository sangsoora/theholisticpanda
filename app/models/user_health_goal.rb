class UserHealthGoal < ApplicationRecord
  belongs_to :user
  belongs_to :health_goal
  validates_uniqueness_of :user, scope: [:health_goal]
end
