# Preview all emails at http://localhost:3000/rails/mailers/session_mailer
class SessionMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/session_mailer/confirm_practitioner
  def confirm_practitioner
    SessionMailer.confirm_practitioner
  end

  # Preview this email at http://localhost:3000/rails/mailers/session_mailer/confirm_user
  def confirm_user
    SessionMailer.confirm_user
  end

end
