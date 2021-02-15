class AdminMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.new_user.subject
  #
  def new_user
    @user = params[:user]

    mail(to: 'hello@theholisticpanda.com', subject: 'New User Joined.')
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.new_practitioner.subject
  #
  def new_practitioner
    @practitioner = params[:practitioner]

    mail(to: 'hello@theholisticpanda.com', subject: 'New Practitioner Application.')
  end
end
