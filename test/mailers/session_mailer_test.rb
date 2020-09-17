require 'test_helper'

class SessionMailerTest < ActionMailer::TestCase
  test "confirm_practitioner" do
    mail = SessionMailer.confirm_practitioner
    assert_equal "Confirm practitioner", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "confirm_user" do
    mail = SessionMailer.confirm_user
    assert_equal "Confirm user", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
