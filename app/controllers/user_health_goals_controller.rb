class UserHealthGoalsController < ApplicationController
    before_action :set_user_health_goal, only: [:destroy]

  def create
    @user_health_goal = UserHealthGoal.new
    authorize @user_health_goal
    @user = User.find(params[:user_id])
    @user_health_goals = HealthGoal.all.sort_by(&:name)
    @user_health_goal.user = @user
    @user_health_goal.health_goal = HealthGoal.find(params[:user][:health_goal_id])
    @health_goals = HealthGoal.all.sort_by(&:name)
    if @user_health_goal.save!
      respond_to do |format|
        format.html {
          if @user.practitioner
            redirect_to practitioner_profile_path(@user.practitioner)
          else
            redirect_to user_path(@user)
          end
        }
        format.js
      end
    end
  end

  def destroy
    @user = @user_health_goal.user
    @user_health_goal.destroy
    @health_goal = @user_health_goal.health_goal
    @health_goals = HealthGoal.all.sort_by(&:name)
    respond_to do |format|
      format.html {
        if @user.practitioner
          redirect_to practitioner_profile_path(@user.practitioner)
        else
          redirect_to user_path(@user)
        end
      }
      format.js
    end
  end

  private

  def set_user_health_goal
    @user_health_goal = UserHealthGoal.find(params[:id])
    authorize @user_health_goal
  end
end
