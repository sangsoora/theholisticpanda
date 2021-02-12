class PractitionerPaymentsController < ApplicationController
  def new
    @practitioner = current_user.practitioner
    authorize @practitioner
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
  end
end
