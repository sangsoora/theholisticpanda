require 'test_helper'

class AdminMailerTest < ActionMailer::TestCase
  test "new_user" do
    mail = AdminMailer.new_user
    assert_equal "New user", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "new_practitioner" do
    mail = AdminMailer.new_practitioner
    assert_equal "New practitioner", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
