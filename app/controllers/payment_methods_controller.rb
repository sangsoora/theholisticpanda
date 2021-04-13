class PaymentMethodsController < ApplicationController
  before_action :set_payment_method, only: %i[update destroy]

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
      Stripe::PaymentMethod.detach(
        @payment_method.payment_method_id,
      )
      @payment_method.destroy
    end
    respond_to do |format|
      format.html { redirect_to user_url(current_user) }
      format.js
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
