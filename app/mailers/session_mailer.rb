class SessionMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.session_mailer.confirm_practitioner.subject
  #
  def confirm_practitioner
    @session = params[:session]

    mail(to: @session.practitioner.user.email, subject: "Your session with #{@session.user.full_name} has been confirmed.")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.session_mailer.confirm_user.subject
  #
  def confirm_user
    @session = params[:session]

    mail(to: @session.user.email, subject: "Your session with #{@session.practitioner.user.full_name} has been confirmed.")
  end
end
