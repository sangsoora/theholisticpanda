class UserHealthGoalsController < ApplicationController
  before_action :set_user_health_goal, only: [:destroy]

  def create
    @user = User.find(params[:user_id])
    new_health_goals = params[:user][:health_goal_ids].reject(&:blank?)
    new_health_goals.each do |goal|
      @user_health_goal = UserHealthGoal.new
      authorize @user_health_goal
      @user_health_goal.user = @user
      @user_health_goal.health_goal = HealthGoal.find(goal)
      @user_health_goal.save!
    end
    @health_goals = HealthGoal.all.sort_by(&:name)
    respond_to do |format|
      format.html {
        if @user.practitioner
          redirect_to practitioner_profile_path
        else
          redirect_to user_path(@user)
        end
      }
      format.js
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
          redirect_to practitioner_profile_path
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
