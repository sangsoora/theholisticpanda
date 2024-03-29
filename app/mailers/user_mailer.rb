class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome
    @user = params[:user]

    mail(to: @user.email, subject: 'Welcome to The Holistic Panda')
  end

  def message_notification
    @user = params[:user]
    @recipient = params[:recipient]
    @conversation = params[:conversation]

    mail(to: @recipient.email, subject: "You received a new message from #{@user.full_name}.")
  end
end
