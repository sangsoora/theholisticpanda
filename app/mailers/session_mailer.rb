require 'icalendar'

class SessionMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.session_mailer.confirm_practitioner.subject
  #
  def confirm_practitioner
    @session = params[:session]
    if @session.service.default_service
      @practitioner = Practitioner.find(@session.free_practitioner_id)
    else
      @practitioner = @session.practitioner
    end
    @cal = Icalendar::Calendar.new
    @cal.event do |e|
      e.dtstart     = @session.start_time.in_time_zone(@practitioner.timezone)
      e.dtend       = @session.start_time.in_time_zone(@practitioner.timezone) + @session.duration.minutes
      e.summary     = @session.service.name
      e.description = "#{@session.service.name} with #{@session.user.full_name} booked through The Holistic Panda."
      e.ip_class    = "PRIVATE"
      if @session.session_type == "Virtual"
        e.url = @session.link
      else
        e.location = @session.address
      end
      e.alarm do |a|
        a.action          = "DISPLAY"
        a.description     = "This is an event reminder for your #{@session.service.name} with #{@session.user.full_name} booked through The Holistic Panda." # email body (required)
        a.summary         = "Your #{@session.service.name} session reminder"     # email subject (required)
        a.attendee        = "mailto:#{@practitioner.user.email}" # one or more email recipients (required)
        a.trigger         = "-P1DT0H0M0S" # 15 minutes before
      end
      e.alarm do |a|
        a.action  = "DISPLAY" # This line isn't necessary, it's the default
        a.summary = "Your #{@session.service.name} session reminder"
        a.trigger = "-PT15M" # 1 day before
      end
    end
    attachments['calendar.ics'] = { mime_type: 'text/calendar', content: @cal.to_ical }
    mail(to: @practitioner.user.email, subject: "You have a confirmed session!")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.session_mailer.confirm_user.subject
  #
  def confirm_user
    @session = params[:session]
    if @session.service.default_service
      @practitioner = Practitioner.find(@session.free_practitioner_id)
    else
      @practitioner = @session.practitioner
    end
    @cal = Icalendar::Calendar.new
    @cal.event do |e|
      e.dtstart     = @session.start_time.in_time_zone(@session.user.timezone)
      e.dtend       = @session.start_time.in_time_zone(@session.user.timezone) + @session.duration.minutes
      e.summary     = @session.service.name
      e.description = "#{@session.service.name} with #{@practitioner.user.full_name} booked through The Holistic Panda."
      e.ip_class    = "PRIVATE"
      if @session.session_type == "Virtual"
        e.url = @session.link
      else
        e.location = @session.address
      end
      e.alarm do |a|
        a.action          = "DISPLAY"
        a.description     = "This is an event reminder for your #{@session.service.name} with #{@practitioner.user.full_name} booked through The Holistic Panda." # email body (required)
        a.summary         = "Your #{@session.service.name} session reminder"     # email subject (required)
        a.attendee        = "mailto:#{@session.user.email}" # one or more email recipients (required)
        a.trigger         = "-P1DT0H0M0S" # 15 minutes before
      end
      e.alarm do |a|
        a.action  = "DISPLAY" # This line isn't necessary, it's the default
        a.summary = "Your #{@session.service.name} session reminder"
        a.trigger = "-PT15M" # 1 day before
      end
    end
    attachments['session.ics'] = { mime_type: 'text/calendar', content: @cal.to_ical }
    mail(to: @session.user.email, subject: "Thank you for booking a session.")
  end

  def cancel_practitioner
    @session = params[:session]
    if @session.service.default_service
      @practitioner = Practitioner.find(@session.free_practitioner_id)
    else
      @practitioner = @session.practitioner
    end
    mail(to: @practitioner.user.email, subject: "Your session has been cancelled")
  end

  def cancel_user
    @session = params[:session]
    if @session.service.default_service
      @practitioner = Practitioner.find(@session.free_practitioner_id)
    else
      @practitioner = @session.practitioner
    end
    mail(to: @session.user.email, subject: "Your session has been cancelled.")
  end

  def cancel_practitioner_within_24
    @session = params[:session]
    @practitioner = @session.practitioner
    mail(to: @practitioner.user.email, subject: "Your session has been cancelled")
  end

  def cancel_user_within_24
    @session = params[:session]
    @practitioner = @session.practitioner
    mail(to: @session.user.email, subject: "Your session has been cancelled.")
  end

  def cancel_practitioner_with_full_charge
    @session = params[:session]
    @practitioner = @session.practitioner
    mail(to: @practitioner.user.email, subject: "Your session has been cancelled")
  end

  def send_request
    @session = params[:session]
    if @session.service.default_service
      @practitioner = Practitioner.find(@session.free_practitioner_id)
    else
      @practitioner = @session.practitioner
    end
    mail(to: @practitioner.user.email, subject: "You have a session request!")
  end

  def decline_request
    @session = params[:session]
    if @session.service.default_service
      @practitioner = Practitioner.find(@session.free_practitioner_id)
    else
      @practitioner = @session.practitioner
    end
    mail(to: @session.user.email, subject: "Your session request has been declined!")
  end

  def review_reminder
    @session = params[:session]
    if @session.service.default_service
      @practitioner = Practitioner.find(@session.free_practitioner_id)
    else
      @practitioner = @session.practitioner
    end
    mail(to: @session.user.email, subject: "Did you enjoy your session? Leave a review!")
  end

  def change_link
    @session = params[:session]
    if @session.service.default_service
      @practitioner = Practitioner.find(@session.free_practitioner_id)
    else
      @practitioner = @session.practitioner
    end
    @cal = Icalendar::Calendar.new
    @cal.event do |e|
      e.dtstart     = @session.start_time.in_time_zone(@session.user.timezone)
      e.dtend       = @session.start_time.in_time_zone(@session.user.timezone) + @session.duration.minutes
      e.summary     = @session.service.name
      e.description = "#{@session.service.name} with #{@practitioner.user.full_name} booked through The Holistic Panda."
      e.ip_class    = "PRIVATE"
      e.url = @session.link
      e.alarm do |a|
        a.action          = "DISPLAY"
        a.description     = "This is an event reminder for your #{@session.service.name} with #{@practitioner.user.full_name} booked through The Holistic Panda." # email body (required)
        a.summary         = "Your #{@session.service.name} session reminder"     # email subject (required)
        a.attendee        = "mailto:#{@session.user.email}" # one or more email recipients (required)
        a.trigger         = "-P1DT0H0M0S" # 15 minutes before
      end
      e.alarm do |a|
        a.action  = "DISPLAY" # This line isn't necessary, it's the default
        a.summary = "Your #{@session.service.name} session reminder"
        a.trigger = "-PT15M" # 1 day before
      end
    end
    attachments['session.ics'] = { mime_type: 'text/calendar', content: @cal.to_ical }
    mail(to: @session.user.email, subject: "Virtual link for your session has been changed!")
  end

  def change_address
    @session = params[:session]
    if @session.service.default_service
      @practitioner = Practitioner.find(@session.free_practitioner_id)
    else
      @practitioner = @session.practitioner
    end
    @cal = Icalendar::Calendar.new
    @cal.event do |e|
      e.dtstart     = @session.start_time.in_time_zone(@session.user.timezone)
      e.dtend       = @session.start_time.in_time_zone(@session.user.timezone) + @session.duration.minutes
      e.summary     = @session.service.name
      e.description = "#{@session.service.name} with #{@practitioner.user.full_name} booked through The Holistic Panda."
      e.ip_class    = "PRIVATE"
      e.location = @session.address
      e.alarm do |a|
        a.action          = "DISPLAY"
        a.description     = "This is an event reminder for your #{@session.service.name} with #{@practitioner.user.full_name} booked through The Holistic Panda." # email body (required)
        a.summary         = "Your #{@session.service.name} session reminder"     # email subject (required)
        a.attendee        = "mailto:#{@session.user.email}" # one or more email recipients (required)
        a.trigger         = "-P1DT0H0M0S" # 15 minutes before
      end
      e.alarm do |a|
        a.action  = "DISPLAY" # This line isn't necessary, it's the default
        a.summary = "Your #{@session.service.name} session reminder"
        a.trigger = "-PT15M" # 1 day before
      end
    end
    attachments['session.ics'] = { mime_type: 'text/calendar', content: @cal.to_ical }
    mail(to: @session.user.email, subject: "Location for your session has been changed!")
  end

  def request_reminder
    @session = params[:session]
    if @session.service.default_service
      @practitioner = Practitioner.find(@session.free_practitioner_id)
    else
      @practitioner = @session.practitioner
    end
    mail(to: @practitioner.user.email, subject: "You have a pending session request.")
  end

  def charge_reminder
    @session = params[:session]
    @practitioner = @session.practitioner
    if @session.free_session
      subject = "Don't forget to click 'Completed' on your session!"
    else
      subject = "Don’t forget to charge your session!"
    end
    mail(to: @practitioner.user.email, subject: subject)
  end

  def complete_request_reminder
    @session = params[:session]
    if @session.service.default_service
      @practitioner = Practitioner.find(@session.free_practitioner_id)
    else
      @practitioner = @session.practitioner
    end
    mail(to: @session.user.email, subject: "Still on your mind?")
  end

  def session_reminder_practitioner
    @session = params[:session]
    if @session.service.default_service
      @practitioner = Practitioner.find(@session.free_practitioner_id)
    else
      @practitioner = @session.practitioner
    end
    @cal = Icalendar::Calendar.new
    @cal.event do |e|
      e.dtstart     = @session.start_time.in_time_zone(@practitioner.timezone)
      e.dtend       = @session.start_time.in_time_zone(@practitioner.timezone) + @session.duration.minutes
      e.summary     = @session.service.name
      e.description = "#{@session.service.name} with #{@session.user.full_name} booked through The Holistic Panda."
      e.ip_class    = "PRIVATE"
      if @session.session_type == "Virtual"
        e.url = @session.link
      else
        e.location = @session.address
      end
      e.alarm do |a|
        a.action          = "DISPLAY"
        a.description     = "This is an event reminder for your #{@session.service.name} with #{@session.user.full_name} booked through The Holistic Panda." # email body (required)
        a.summary         = "Your #{@session.service.name} session reminder"     # email subject (required)
        a.attendee        = "mailto:#{@practitioner.user.email}" # one or more email recipients (required)
        a.trigger         = "-P1DT0H0M0S" # 15 minutes before
      end
      e.alarm do |a|
        a.action  = "DISPLAY" # This line isn't necessary, it's the default
        a.summary = "Your #{@session.service.name} session reminder"
        a.trigger = "-PT15M" # 1 day before
      end
    end
    attachments['calendar.ics'] = { mime_type: 'text/calendar', content: @cal.to_ical }
    mail(to: @practitioner.user.email, subject: "Session Reminder: #{@session.service.name} with #{@session.user.full_name}")
  end

  def session_reminder_user
    @session = params[:session]
    if @session.service.default_service
      @practitioner = Practitioner.find(@session.free_practitioner_id)
    else
      @practitioner = @session.practitioner
    end
    @cal = Icalendar::Calendar.new
    @cal.event do |e|
      e.dtstart     = @session.start_time.in_time_zone(@session.user.timezone)
      e.dtend       = @session.start_time.in_time_zone(@session.user.timezone) + @session.duration.minutes
      e.summary     = @session.service.name
      e.description = "#{@session.service.name} with #{@practitioner.user.full_name} booked through The Holistic Panda."
      e.ip_class    = "PRIVATE"
      if @session.session_type == "Virtual"
        e.url = @session.link
      else
        e.location = @session.address
      end
      e.alarm do |a|
        a.action          = "DISPLAY"
        a.description     = "This is an event reminder for your #{@session.service.name} with #{@practitioner.user.full_name} booked through The Holistic Panda." # email body (required)
        a.summary         = "Your #{@session.service.name} session reminder"     # email subject (required)
        a.attendee        = "mailto:#{@session.user.email}" # one or more email recipients (required)
        a.trigger         = "-P1DT0H0M0S" # 15 minutes before
      end
      e.alarm do |a|
        a.action  = "DISPLAY" # This line isn't necessary, it's the default
        a.summary = "Your #{@session.service.name} session reminder"
        a.trigger = "-PT15M" # 1 day before
      end
    end
    attachments['session.ics'] = { mime_type: 'text/calendar', content: @cal.to_ical }
    mail(to: @session.user.email, subject: "Session Reminder: #{@session.service.name} with #{@practitioner.user.full_name}")
  end
end
