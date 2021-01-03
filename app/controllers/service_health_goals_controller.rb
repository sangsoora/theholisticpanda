class ServiceHealthGoalsController < ApplicationController
  before_action :set_service_health_goal, only: [:destroy]

  private

  def set_service_health_goal
    @service_health_goal = ServiceHealthGoal.find(params[:id])
    authorize @service_health_goal
  end
end
