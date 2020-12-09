class ServiceHealthGoal < ApplicationRecord
  belongs_to :service
  belongs_to :health_goal
end
