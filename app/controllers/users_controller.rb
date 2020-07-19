class UsersController < ApplicationController
  before_action :set_user, only: [:show, :booking]
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
      @bookings = current_user.practitioner.sessions.where(["status= ?", "confirmed"])
      @confirmed_bookings = current_user.practitioner.sessions.where(["status= ?", "confirmed"])
      @pending_bookings = current_user.practitioner.sessions.where(["paid = ? AND status= ?", true, "pending"])
      @cancelled_bookings = current_user.practitioner.sessions.where(["status= ?", "cancelled"])
    else
      @bookings = Session.where(["user_id = ? AND status= ?", @user.id, "confirmed"])
      @confirmed_bookings = Session.where(["user_id = ? AND status= ?", @user.id, "confirmed"])
      @pending_bookings = Session.where(["user_id = ? AND status= ?", @user.id, "pending"])
      @cancelled_bookings = Session.where(["status= ?", "cancelled"])
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end
end
