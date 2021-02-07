class ApplicationMailer < ActionMailer::Base
  default(
    from: "TheHolisticPanda <hello@theholisticpanda.com>",
    reply_to: "TheHolisticPanda <hello@theholisticpanda.com>"
  )
  layout 'mailer'
end
