class StripeCustomerService
  def call(event)
    customer_id = event.data.object.id
    User.find(4).update(stripe_id: customer_id)
  end
end
