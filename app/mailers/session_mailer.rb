require 'icalendar'

class SessionMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.session_mailer.confirm_practitioner.subject
  #
  def confirm_practitioner
    attachments.inline["email-logo.png"] = File.read("#{Rails.root}/app/assets/images/email-logo.png")
    @session = params[:session]
    if @session.session_type == "Virtual"
      url = @session.link
    else
      url = ''
    end
    @cal = Icalendar::Calendar.new
    @cal.event do |e|
      e.dtstart     = @session.start_time
      e.dtend       = @session.start_time + @session.duration.minutes
      e.summary     = @session.service.name
      e.description = "#{@session.service.name} with #{@session.user.full_name} booked through The Holistic Panda."
      e.ip_class    = "PRIVATE"
      e.url = url
      e.alarm do |a|
        a.action          = "DISPLAY"
        a.description     = "This is an event reminder for your #{@session.service.name} with #{@session.user.full_name} booked through The Holistic Panda." # email body (required)
        a.summary         = "Your #{@session.service.name} session reminder"     # email subject (required)
        a.attendee        = "mailto:#{@session.practitioner.user.email}" # one or more email recipients (required)
        a.trigger         = "-P1DT0H0M0S" # 15 minutes before
      end
      e.alarm do |a|
        a.action  = "DISPLAY" # This line isn't necessary, it's the default
        a.summary = "Your #{@session.service.name} session reminder"
        a.trigger = "-PT15M" # 1 day before
      end
    end
    mail.attachments['calendar.ics'] = { mime_type: 'text/calendar', content: @cal.to_ical }
    mail(to: @session.practitioner.user.email, subject: "You have a confirmed session!")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.session_mailer.confirm_user.subject
  #
  def confirm_user
    attachments.inline["email-logo.png"] = File.read("#{Rails.root}/app/assets/images/email-logo.png")
    @session = params[:session]
    if @session.session_type == "Virtual"
      url = @session.link
    else
      url = ''
    end
    @cal = Icalendar::Calendar.new
    @cal.event do |e|
      e.dtstart     = @session.start_time
      e.dtend       = @session.start_time + @session.duration.minutes
      e.summary     = @session.service.name
      e.description = "#{@session.service.name} with #{@session.practitioner.user.full_name} booked through The Holistic Panda."
      e.ip_class    = "PRIVATE"
      e.url = url
      e.alarm do |a|
        a.action          = "DISPLAY"
        a.description     = "This is an event reminder for your #{@session.service.name} with #{@session.practitioner.user.full_name} booked through The Holistic Panda." # email body (required)
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
    mail.attachments['session.ics'] = { mime_type: 'text/calendar', content: @cal.to_ical }
    mail(to: @session.user.email, subject: "Thank you for booking a session.")
  end

  def cancel_practitioner
    attachments.inline["email-logo.png"] = File.read("#{Rails.root}/app/assets/images/email-logo.png")
    @session = params[:session]
    mail(to: @session.practitioner.user.email, subject: "Your session has been cancelled")
  end

  def cancel_user
    attachments.inline["email-logo.png"] = File.read("#{Rails.root}/app/assets/images/email-logo.png")
    @session = params[:session]
    mail(to: @session.user.eamil, subject: "Your session has been cancelled.")
  end

  def send_request
    attachments.inline["email-logo.png"] = File.read("#{Rails.root}/app/assets/images/email-logo.png")
    @session = params[:session]
    mail(to: @session.practitioner.user.email, subject: "You have a session request!")
  end

  def decline_request
    attachments.inline["email-logo.png"] = File.read("#{Rails.root}/app/assets/images/email-logo.png")
    @session = params[:session]
    mail(to: @session.user.email, subject: "You have a session request!")
  end

  def change_link
    attachments.inline["email-logo.png"] = File.read("#{Rails.root}/app/assets/images/email-logo.png")
    @session = params[:session]
    mail(to: @session.user.email, subject: "You have a session request!")
  end
end
