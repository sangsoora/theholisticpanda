class NotificationsController < ApplicationController
  before_action :set_notification, only: [:update, :destroy]

  # def index
  #   @notifications = policy_scope(Notification).order(created_at: :desc)
  # end

  def update
    if @notification.read_at.nil?
      @notification.update!(read_at: Time.zone.now)
    end
    if @notification.notifiable_type == "Session"
      redirect_to session_path(@notification.notifiable_id)
    elsif @notification.notifiable_type == "Service"
      redirect_to service_path(@notification.notifiable_id)
    elsif @notification.notifiable_type == "Conversation"
      redirect_to conversation_path(@notification.notifiable_id)
    #    # redirect_to user_notifications_path(@notification.recipient)
    end
  end

  def destroy
    @notification.destroy
    @notifications = Notification.where(recipient: current_user).order("created_at DESC").unread
  end

  private

  def set_notification
    @notification = Notification.includes(:actor).find(params[:id])
    authorize @notification
  end
end
