class UsersController < ApplicationController
  before_action :set_user, only: [:show, :booking, :favorite, :notification]
  before_action :set_notifications, only: [:show, :booking, :favorite, :notification]
  helper_method :resource_name, :resource, :devise_mapping, :resource_class

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def show
  end

  def booking
    if current_user.practitioner
      @confirmed_sessions = current_user.practitioner.sessions.where(["status= ?", "confirmed"])
      @pending_sessions = current_user.practitioner.sessions.where(["paid = ? AND status= ?", true, "pending"])
      @cancelled_sessions = current_user.practitioner.sessions.where(["status= ?", "cancelled"])
    else
      @confirmed_sessions = current_user.sessions.where(["status= ?", "confirmed"])
      @pending_sessions = current_user.sessions.where(["status= ?", "pending"])
      @cancelled_sessions = current_user.sessions.where(["status= ?", "cancelled"])
    end
    @review = Review.new
  end

  def favorite
    @favorite_practitioners = current_user.favorite_practitioners
    @favorite_services = current_user.favorite_services
  end

  def notification
    @my_notifications = Notification.where(recipient: current_user).order("created_at DESC")
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end

  def set_notifications
    @notifications = Notification.where(recipient: current_user).order("created_at DESC").unread
  end
end
