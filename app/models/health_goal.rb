class HealthGoal < ApplicationRecord
  has_many :user_health_goals
  has_many :service_health_goals
  has_many :users, through: :user_health_goals
  has_many :services, through: :service_health_goals
  has_many :practitioners, through: :services
end
