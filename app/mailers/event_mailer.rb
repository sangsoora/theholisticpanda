require 'icalendar'

class EventMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.confirmation.subject
  #
  def confirmation
    @event = params[:event]
    @event_attendee = params[:event_attendee]

    @cal = Icalendar::Calendar.new
    @cal.event do |e|
      e.dtstart     = @event.start_time.in_time_zone('America/Vancouver')
      e.dtend       = @event.start_time.in_time_zone('America/Vancouver') + @event.duration.minutes
      e.summary     = @event.name
      e.description = "#{@event.name}."
      e.ip_class    = "PRIVATE"
      e.location = 'Formation Studio 16 E 5th Ave, Vancouver, Canada'

      e.alarm do |a|
        a.action          = "DISPLAY"
        a.description     = "This is an event reminder for #{@event.name}." # email body (required)
        a.summary         = "#{@event.name} reminder"     # email subject (required)
        a.attendee        = "mailto:#{@event_attendee.email}" # one or more email recipients (required)
        a.trigger         = "-P1DT0H0M0S" # 15 minutes before
      end
      e.alarm do |a|
        a.action  = "DISPLAY" # This line isn't necessary, it's the default
        a.summary = "#{@event.name} reminder"
        a.trigger = "-PT1H" # 1 day before
      end
    end
    attachments['calendar.ics'] = { mime_type: 'text/calendar', content: @cal.to_ical }

    mail(to: @event_attendee.email, subject: 'Your Tickets to Finding Wellness with The Holistic Panda.')
  end

  def coupon
    @event = params[:event]
    @event_attendee = params[:event_attendee]

    @coupons = @event.event_codes

    mail(to: @event_attendee.email, subject: 'Your promotion offers are here!')
  end
end
