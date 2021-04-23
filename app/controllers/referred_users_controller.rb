class ReferredUsersController < ApplicationController

  def create
    @referred_user = ReferredUser.new(referred_user_params)
    authorize @referred_user
    @referred_user.user = current_user
    if @referred_user.save!
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
  end

  private

  def referred_user_params
    params.require(:referred_user).permit(:email, :user_id, :invite_token)
  end
end
