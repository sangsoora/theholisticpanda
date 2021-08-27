class EventAttendeePaymentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new]

  def new
    @event_attendee = EventAttendee.find(params[:event_attendee_id])
    authorize @event_attendee
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
  end
end
