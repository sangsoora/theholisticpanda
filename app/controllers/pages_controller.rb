class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :become_a_practitioner, :aboutus, :faq, :terms, :privacy, :cookie]
  before_action :set_notifications, only: [:home, :become_a_practitioner, :aboutus, :faq, :terms, :privacy, :cookie]

  def home
    @needs = Need.all
    @offer = Offer.where(active: true).first
    practitioners = Practitioner.checked_practitioners.includes(user: [:photo_attachment])
    @featured_practitioners = []
    practitioners.each do |practitioner|
      @featured_practitioners << practitioner if practitioner.minimum_profile?
    end
    @filtered_services_goals = []
    Service.active_services.each do |service|
      service.health_goals.each do |goal|
        if !@filtered_services_goals.include?(goal)
          @filtered_services_goals << goal
        end
      end
    end
  end

  def become_a_practitioner
  end

  def aboutus
  end

  def faq
  end

  def terms
  end

  def privacy
  end

  def cookie
  end

  private

  def set_notifications
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
  end
end
