class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_event, only: %i[show update destroy]
  before_action :set_notifications, only: %i[index show]

  def index
    @events = policy_scope(Event)
    @upcoming_events = @events.where('start_time > ?', Time.current)
    @past_events = @events.where('start_time <= ?', Time.current)
  end

  def create
    @event = Event.new(event_params)
    authorize @event
    @event.user = User.find(params[:event][:user])
    @event.save!
    redirect_to events_path
  end

  def show
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
