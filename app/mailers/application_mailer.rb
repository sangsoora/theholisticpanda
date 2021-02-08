class ApplicationMailer < ActionMailer::Base
  default(
    from: "The Holistic Panda Team <hello@theholisticpanda.com>",
    reply_to: "The Holistic Panda Team <hello@theholisticpanda.com>"
  )
  layout 'mailer'
end
