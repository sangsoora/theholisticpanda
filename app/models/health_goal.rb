class HealthGoal < ApplicationRecord
  has_many :user_health_goals
  has_many :specialty_health_goals
  has_many :users, through: :user_health_goals
  has_many :specialties, through: :specialty_health_goals
  has_many :practitioner, through: :specialties
end
