class PractitionerMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.practitioner_mailer.welcome.subject
  #
  def welcome
    attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/logo.png")
    @practitioner = params[:practitioner]

    mail(to: @practitioner.user.email, subject: 'Your practitioner application has been submitted.')
  end
end
