class EventAttendeesController < ApplicationController
  before_action :set_event_attendee, only: [:destroy]

  def create
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
    params.require(:practitioner).permit(:first_name, :last_name, :email, :duration, :event_consent, :newsletter)
  end
end
