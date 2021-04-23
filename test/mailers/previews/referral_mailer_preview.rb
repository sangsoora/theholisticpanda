# Preview all emails at http://localhost:3000/rails/mailers/referral_mailer
class ReferralMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/referral_mailer/new_invite
  def new_invite
    ReferralMailer.new_invite
  end

  # Preview this email at http://localhost:3000/rails/mailers/referral_mailer/existing_user_coupon
  def existing_user_coupon
    ReferralMailer.existing_user_coupon
  end

  # Preview this email at http://localhost:3000/rails/mailers/referral_mailer/new_user_coupon
  def new_user_coupon
    ReferralMailer.new_user_coupon
  end

end
