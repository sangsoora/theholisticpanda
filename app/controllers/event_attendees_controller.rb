class EventAttendeesController < ApplicationController
  before_action :set_event_attendee, only: [:destroy]
  skip_before_action :authenticate_user!, only: [:create]

  def create
    @event_attendee = EventAttendee.new(event_attendee_params)
    authorize @event_attendee
    @event_attendee.event = Event.find(params[:event_id])
    @event_attendee.save!
    SubscribeToNewsletterService.new(@event_attendee).call
    if user_signed_in?
      customer = current_user.stripe_id
    else
      customer = Stripe::Customer.create({
        email: @event_attendee.email,
        name: @event_attendee.full_name
      })
      customer = customer.id
    end
    tax_rates = [TaxRate.find(4).tax_id]
    begin
      payment_session = Stripe::Checkout::Session.create(
        billing_address_collection: 'required',
        payment_method_types: ['card'],
        customer: customer,
        line_items: [{
          name: @event_attendee.event.name,
          amount: 7500,
          currency: 'cad',
          quantity: 1,
          tax_rates: tax_rates
        }],
        success_url: event_url(@event_attendee.event) + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: event_url(@event_attendee.event)
      )
      @event_attendee.update(checkout_session_id: payment_session.id)
      redirect_to new_event_attendee_event_attendee_payment_path(@event_attendee)
    rescue Stripe::StripeError => e
      type = e.error.type if e.error.type
      code = e.error.code if e.error.code
      message = e.error.message if e.error.message
      AdminMailer.with(user: @event_attendee, request: 'Event registration', type: type, code: code, message: message).stripe_failure.deliver_now
      redirect_to event_url(@event_attendee.event), alert: 'Oops! Something went wrong.'
    end
  end

  def destroy
    @event_attendee.destroy
    redirect_to event_path(@event)
  end

  private

  def set_event_attendee
    @event_attendee = EventAttendee.find(params[:id])
    authorize @event_attendee
  end

  def event_attendee_params
    params.require(:event_attendee).permit(:first_name, :last_name, :email, :event_consent, :terms_consent, :newsletter, :checkout_session_id, :price, :payment_status, :event_id)
  end
end
