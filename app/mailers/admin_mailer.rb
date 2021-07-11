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

  def stripe_failure
    @user = params[:user]
    @request = params[:request]
    @type = params[:type] if params[:type]
    @code = params[:code] if params[:code]
    @message = params[:message] if params[:message]

    mail(to: 'tech@theholisticpanda.com', subject: 'Stripe error occured.')
  end
end
