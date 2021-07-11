class PaymentMethodsController < ApplicationController
  before_action :set_payment_method, only: %i[update destroy]

  def create
  end

  def update
    PaymentMethod.find_by(default: true).update(default: false)
    @payment_method.update(default: true)
    respond_to do |format|
      format.html { redirect_to user_url(current_user) }
      format.js
    end
  end

  def destroy
    if !@payment_method.default
      begin
        Stripe::PaymentMethod.detach(
          @payment_method.payment_method_id
        )
        @payment_method.destroy
        respond_to do |format|
          format.html { redirect_to user_url(current_user) }
          format.js
        end
      rescue Stripe::StripeError => e
        type = e.error.type if e.error.type
        code = e.error.code if e.error.code
        message = e.error.message if e.error.message
        AdminMailer.with(user: @payment_method.user, request: 'Payment method detach', type: type, code: code, message: message).stripe_failure.deliver_now
        redirect_to user_url(current_user), alert: 'Oops! Something went wrong.'
      rescue => e
        type = e.error.type if e.error.type
        code = e.error.code if e.error.code
        message = e.error.message if e.error.message
        AdminMailer.with(user: @payment_method.user, request: 'Payment method detach', type: type, code: code, message: message).stripe_failure.deliver_now
        redirect_to user_url(current_user), alert: 'Oops! Something went wrong.'
      end
    end
  end

  private

  def set_payment_method
    @payment_method = PaymentMethod.find(params[:id])
    authorize @payment_method
  end

  def payment_method_params
    params.require(:payment_method).permit(:certification_type, :name)
  end
end
