class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :become_a_practitioner]
  before_action :set_notifications, only: [:home, :become_a_practitioner]

  def home
    @practitioners = Practitioner.includes(user: [:photo_attachment])
    @newsletter = Newsletter.new
  end

  def become_a_practitioner
  end

  private

  def set_notifications
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
  end
end
