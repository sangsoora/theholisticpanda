class EventCodesController < ApplicationController
  before_action :set_event_code, only: [:destroy]

  def create
    @event_code = EventCode.new(event_code_params)
    authorize @event_code
    @event_code.event = Event.find(params[:event_id])
    @event_code.save!
    begin
      if @event_code.detail.include?('%')
        coupon = Stripe::Coupon.create({
          percent_off: @event_code.detail.split('%')[0].to_f,
          duration: 'once',
          name: @event_code.name,
          id: @event_code.event.name.downcase.split(' ').join('_') + '_' + @event_code.id.to_s + '_test'
        })
      else
        coupon = Stripe::Coupon.create({
          amount_off: (@event_code.detail.split('$')[0].to_i * 100),
          currency: 'cad',
          duration: 'once',
          name: @event_code.name,
          id: @event_code.event.name.downcase.split(' ').join('_') + '_' + @event_code.id.to_s + '_test'
        })
      end
      @event_code.update(coupon_id: coupon.id)
      redirect_to event_codes_path(@event_code.event)
    rescue Stripe::StripeError => e
      type = e.error.type if e.error.type
      code = e.error.code if e.error.code
      message = e.error.message if e.error.message
      AdminMailer.with(user: current_user, request: 'Event coupon create', type: type, code: code, message: message).stripe_failure.deliver_now
      redirect_to event_codes_path(@event_code.event), alert: 'Oops! Something went wrong.'
    end
  end

  def destroy
    if @event_code.coupon_id
      begin
        Stripe::Coupon.delete(@event_code.coupon_id)
        @event_code.destroy
        redirect_to event_codes_path(@event_code.event)
      rescue Stripe::StripeError => e
        type = e.error.type if e.error.type
        code = e.error.code if e.error.code
        message = e.error.message if e.error.message
        AdminMailer.with(user: current_user, request: 'Event coupon delete', type: type, code: code, message: message).stripe_failure.deliver_now
        redirect_to event_codes_path(@event_code.event), alert: 'Oops! Something went wrong.'
      end
    else
      @event_code.destroy
      redirect_to event_codes_path(@event_code.event)
    end
  end

  private

  def set_event_code
    @event_code = EventCode.find(params[:id])
    authorize @event_code
  end

  def event_code_params
    params.require(:event_code).permit(:name, :expires_at, :detail, :coupon_id, :promo_type, :discount_on, :service_id, :practitioner_id, :event_id, :published, :code_name)
  end
end
