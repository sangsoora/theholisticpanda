# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/admin_mailer/new_user
  def new_user
    AdminMailer.new_user
  end

  # Preview this email at http://localhost:3000/rails/mailers/admin_mailer/new_practitioner
  def new_practitioner
    AdminMailer.new_practitioner
  end

end
