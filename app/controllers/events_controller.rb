class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_event, only: %i[show update destroy]
  before_action :set_notifications, only: %i[index show]

  def index
    @events = policy_scope(Event)
  end

  def create
  end

  def show
  end

  def update
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
    params.require(:practitioner).permit(:name, :description, :start_time, :duration, :link)
  end
end
