class PaymentsController < ApplicationController
  def new
    @session = current_user.sessions.where(status: nil).find(params[:session_id])
    authorize @session
    @default_payment_method = current_user.payment_methods.find_by(default: true)
    @promos = current_user.user_promos.where('expires_at > ? AND active = ?', Time.now, true).order('expires_at')
    if @default_payment_method
      @billing_country = @default_payment_method.billing_country
      @billing_state = @default_payment_method.billing_state
    end
    @resource = current_user
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
  end

  def payment
    @user = current_user
    authorize @user
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
  end
end
