class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_event, only: %i[show codes update destroy publish_codes]
  before_action :set_notifications, only: %i[index show codes]

  def index
    @events = policy_scope(Event)
    @upcoming_events = @events.where('start_time > ?', Time.current).order(start_time: :desc)
    @past_events = @events.where('start_time <= ?', Time.current).order(start_time: :desc)
  end

  def create
    @event = Event.new(event_params)
    authorize @event
    @event.user = User.find(params[:event][:user_id])
    @event.save!
    redirect_to events_path
  end

  def show
    @event_attendee = EventAttendee.new
  end

  def codes
    @event_codes = @event.event_codes
    @event_code = EventCode.new
  end

  def publish_codes
    @event_codes = @event.event_codes.where(published: false)
    @event.event_attendees.where('payment_status = ? OR payment_status = ?', 'paid', 'invitee').each do |attendee|
      @event_codes.each do |code|
        begin
          new_code = Stripe::PromotionCode.create({
            coupon: code.coupon_id,
            max_redemptions: 1,
            active: true,
          })
          if code.service != nil
            UserPromo.create(name: code.code_name + '@' + code.id.to_s + '/' + attendee.id.to_s, detail: code.detail, promo_id: new_code.id, active: true, expires_at: code.expires_at, coupon_id: code.coupon_id, promo_type: code.promo_type, discount_on: code.discount_on, service: code.service)
          elsif code.practitioner != nil
            UserPromo.create(name: code.code_name + '@' + code.id.to_s + '/' + attendee.id.to_s, detail: code.detail, promo_id: new_code.id, active: true, expires_at: code.expires_at, coupon_id: code.coupon_id, promo_type: code.promo_type, discount_on: code.discount_on, practitioner: code.practitioner)
          else
            UserPromo.create(name: code.code_name + '@' + code.id.to_s + '/' + attendee.id.to_s, detail: code.detail, promo_id: new_code.id, active: true, expires_at: code.expires_at, coupon_id: code.coupon_id, promo_type: code.promo_type, discount_on: code.discount_on)
          end
        rescue Stripe::StripeError => e
          type = e.error.type if e.error.type
          code = e.error.code if e.error.code
          message = e.error.message if e.error.message
          AdminMailer.with(user: current_user, request: 'Event attendee promo create', type: type, code: code, message: message).stripe_failure.deliver_now
        end
      end
      EventMailer.with(event: @event, event_attendee: attendee).coupon.deliver_now
    end
    @event_codes.each do |code|
      code.update(published: true)
    end
    flash[:notice] = 'Event attendees\' codes have been published!'
    redirect_to event_codes_path(@event)
  end

  def update
    if @event.update(event_params)
      flash[:notice] = 'Event has been successfully updated!'
    else
      flash[:alert] = 'Something went wrong!'
    end
    redirect_to event_path(@event)
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  private

  def set_event
    @event = Event.find(params[:id])
    authorize @event
  end

  def set_notifications
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
  end

  def event_params
    params.require(:event).permit(:name, :description, :start_time, :duration, :link, :capacity, :registration_link, :photo)
  end
end
