namespace :session do
  desc 'Remind practitioner to charge completed session running hourly'
  task charge_reminder: :environment do
    Session.all.where(status: 'confirmed').each do |session|
      unless session.service.default_service
        if (((Time.current - (session.start_time + session.duration.minutes)) / 1.hour) >= 2) && session.practitioner_charge_reminder.nil?
          SessionMailer.with(session: session).charge_reminder.deliver_now
          session.update(practitioner_charge_reminder: 1)
        elsif (((Time.current - (session.start_time + session.duration.minutes)) / 1.hour) >= 26) && session.practitioner_charge_reminder == 1
          SessionMailer.with(session: session).charge_reminder.deliver_now
          session.update(practitioner_charge_reminder: 2)
        end
      end
    end
  end

  desc 'Remind user to complete request for booking running hourly'
  task complete_request_reminder: :environment do
    Session.all.where(status: nil).each do |session|
      if (((Time.current - session.updated_at) / 1.hour) >= 24) && session.user_checkout_reminder.nil?
        SessionMailer.with(session: session).complete_request_reminder.deliver_now
        session.update(user_checkout_reminder: 1)
      end
    end
  end

  desc 'Remind practitioner to respond to user request running every 10 mins'
  task request_reminder: :environment do
    Session.all.where(status: 'pending').each do |session|
      if (((Time.current - session.updated_at) / 1.hour) >= 24) && session.practitioner_request_reminder.nil?
        SessionMailer.with(session: session).request_reminder.deliver_now
        session.update(practitioner_request_reminder: 1)
      elsif (((Time.current - session.updated_at) / 1.hour) >= 24) && session.practitioner_request_reminder == 1
        SessionMailer.with(session: session).request_reminder.deliver_now
        session.update(practitioner_request_reminder: 2)
      end
    end
  end

  desc 'Remind practitioner and user for upcoming session running hourly'
  task session_reminder: :environment do
    Session.all.where(status: 'confirmed').each do |session|
      if (((session.start_time - Time.current) / 1.hour) <= 48) && (((session.start_time - Time.current) / 1.hour) > 47)
        SessionMailer.with(session: session).session_reminder_practitioner.deliver_now
        SessionMailer.with(session: session).session_reminder_user.deliver_now
      end
    end
  end
end
