# Preview all emails at http://localhost:3000/rails/mailers/practitioner_mailer
class PractitionerMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/practitioner_mailer/welcome
  def welcome
    PractitionerMailer.welcome
  end

end
