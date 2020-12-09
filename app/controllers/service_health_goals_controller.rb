class ServiceHealthGoalsController < ApplicationController
  before_action :set_service_health_goal, only: %i[update destroy]

  private

  def set_service_health_goal
    @service_health_goal = ServiceHealthGoal.find(params[:id])
    authorize @service_health_goal
  end

  def service_health_goal_params
    params.require(:working_hour).permit(:day, :opens, :closes)
  end
end
