class ReferredUsersController < ApplicationController
  def create
    @referred_user = ReferredUser.new(referred_user_params)
    authorize @referred_user
    @referred_user.user = current_user
    respond_to do |format|
      if @referred_user.invalid?
        format.html { render root_path }
        format.json { render json: @referred_user.errors, status: :unprocessable_entity }
        format.js   { render layout: false, content_type: 'text/javascript' }
      elsif @referred_user.save!
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
