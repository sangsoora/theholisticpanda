class PaymentsController < ApplicationController
  def new
    @session = current_user.sessions.where(status: 'pending').find(params[:session_id])
    authorize @session
    @notifications = Notification.includes(:actor).includes(:actor).where(recipient: current_user).order("created_at DESC").unread
  end
end
