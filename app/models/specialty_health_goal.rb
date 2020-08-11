class SpecialtyHealthGoal < ApplicationRecord
  belongs_to :specialty
  belongs_to :health_goal
  validates_uniqueness_of :specialty, scope: [:health_goal]
end
