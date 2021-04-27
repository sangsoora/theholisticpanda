class ReferralMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.referral_mailer.new_invite.subject
  #
  def new_invite
    @referred_user = params[:referred_user]

    mail(to: @referred_user.email, subject: 'You have been invited to join The Holistic Panda!')
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.referral_mailer.existing_user_coupon.subject
  #
  def existing_user_coupon
    @referred_user = params[:referred_user]
    @user = params[:user]

    mail(to: @referred_user.user.email, subject: 'Your coupon has been activated.')
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.referral_mailer.new_user_coupon.subject
  #
  def new_user_coupon
    @user = params[:user]

    mail(to: @user.email, subject: 'Your coupon has been activated.')
  end
end
