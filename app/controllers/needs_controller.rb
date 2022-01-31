class NeedsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_need, only: [:show]
  before_action :set_notifications, only: [:show]

  def show
    @need_services = @need.need_services
  end

  private

  def set_need
    @need = Need.find(params[:id])
    authorize @need
  end

  def set_notifications
    @notifications = Notification.includes(:actor).where(recipient: current_user).order('created_at DESC').unread
  end
end
