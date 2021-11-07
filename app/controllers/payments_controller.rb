class PaymentsController < ApplicationController
  def new
    @session = current_user.sessions.where(status: nil).find(params[:session_id])
    authorize @session
    @default_payment_method = current_user.payment_methods.find_by(default: true)
    @general_coupon = current_user.user_promos.where('expires_at > ? AND active = ? AND promo_type = ? AND service_id IS ? AND practitioner_id IS ?', Time.current, true, 'coupon', nil, nil).order('expires_at')
    @service_coupon = current_user.user_promos.where('expires_at > ? AND active = ? AND promo_type = ? AND service_id = ? AND practitioner_id IS ?', Time.current, true, 'coupon', @session.service.id, nil).order('expires_at')
    @practitioner_coupon = current_user.user_promos.where('expires_at > ? AND active = ? AND promo_type = ? AND service_id IS ? AND practitioner_id = ?', Time.current, true, 'coupon', nil, @session.practitioner.id).order('expires_at')
    @all_coupons = @general_coupon + @service_coupon + @practitioner_coupon
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
