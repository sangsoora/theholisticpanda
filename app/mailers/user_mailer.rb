class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome
    attachments.inline["email-logo.png"] = File.read("#{Rails.root}/app/assets/images/email-logo.png")
    @user = params[:user]

    mail(to: @user.email, subject: 'Welcome to The Holistic Panda')
  end
end
