class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :set_notifications, only: %i[show booking favorite notification]
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
    @newsletter = Newsletter.find_by(email: @user.email) if @user.newsletter
    @user_health_goal = UserHealthGoal.new
    @health_goals = HealthGoal.all
  end

  def booking
    @user = current_user
    authorize @user
    @confirmed_sessions = current_user.sessions.where(free_practitioner_id: nil).includes(:review, service: [practitioner: [{user: :photo_attachment}]]).where(['status= ?', 'confirmed'])
    @pending_sessions = current_user.sessions.where(free_practitioner_id: nil).includes(:review, service: [practitioner: [{user: :photo_attachment}]]).where(['status= ?', 'pending'])
    @cancelled_sessions = current_user.sessions.where(free_practitioner_id: nil).includes(:review, service: [practitioner: [{user: :photo_attachment}]]).where(['status= ?', 'cancelled'])
    @discovery_calls = current_user.sessions.where.not(free_practitioner_id: nil).includes(:review, :service)
    @review = Review.new
  end

  def favorite
    @user = current_user
    authorize @user
    @favorite_practitioners = current_user.favorite_practitioners.includes(practitioner: :user)
    @favorite_services = current_user.favorite_services.includes(:service)
  end

  def notification
    @user = current_user
    authorize @user
    @my_notifications = Notification.includes(actor: [practitioner: [{user: :photo_attachment}]]).where(recipient: current_user).order('created_at DESC')
  end

  private

  def set_user
    @user = User.includes(:practitioner).find(params[:id])
    authorize @user
  end

  def set_notifications
    @notifications = Notification.includes(:actor).where(recipient: current_user).order('created_at DESC').unread
  end
end
