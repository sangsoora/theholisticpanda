class StripeCustomerPaymentService
  def call(event)
    if User.find_by(stripe_id: event.data.object.customer)
      @user = User.find_by(stripe_id: event.data.object.customer)
      PaymentMethod.find_by(user: @user, default: true)&.update(default: false)
      PaymentMethod.create(user: @user, payment_method_id: event.data.object.id, last4: event.data.object.card.last4, billing_country: event.data.object.billing_details.address.country, billing_state: event.data.object.billing_details.address.state, default: true)
      @user.update!(setup_session_id: nil)
    end
  end
end
