class PractitionerMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.practitioner_mailer.welcome.subject
  #
  def welcome
    @practitioner = params[:practitioner]

    mail(to: @practitioner.user.email, subject: 'Your practitioner application has been submitted.')
  end
end
