require 'test_helper'

class ReferralMailerTest < ActionMailer::TestCase
  test "new_invite" do
    mail = ReferralMailer.new_invite
    assert_equal "New invite", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "existing_user_coupon" do
    mail = ReferralMailer.existing_user_coupon
    assert_equal "Existing user coupon", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "new_user_coupon" do
    mail = ReferralMailer.new_user_coupon
    assert_equal "New user coupon", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
