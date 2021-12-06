namespace :practitioner do
  desc 'Remind practitioner to complete mandatory fields in profile'
  task profile_reminder: :environment do
    Practitioner.all.each do |practitioner|
      if practitioner.need_profile_reminder? && !practitioner.activated_at.nil?
        if ((Time.current - practitioner.activated_at) / 1.day) >= 7 && practitioner.setup_profile_reminder.nil?
          PractitionerMailer.with(practitioner: practitioner).profile_reminder.deliver_now
          practitioner.update(setup_profile_reminder: 1)
        elsif ((Time.current - practitioner.activated_at) / 1.day) >= 12 && practitioner.setup_profile_reminder == 1
          PractitionerMailer.with(practitioner: practitioner).profile_reminder.deliver_now
          practitioner.update(setup_profile_reminder: 2)
        end
      end
    end
  end
end
