class SubscribeToNewsletterService
  def initialize(user)
    @user = user
    @gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'])
    @audience_id = ENV['MAILCHIMP_AUDIENCE_ID']
  end

  def call
    member_id = Digest::MD5.hexdigest(@user.email)
    begin
      if (@gibbon.lists(@audience_id).members(member_id).retrieve.body[:status] != 'subscribed') && (@user.newsletter)
        @gibbon.lists(@audience_id).members(member_id).update(body: { status: "subscribed" })
      end
    rescue
      if @user.newsletter
        @gibbon.lists(@audience_id).members.create(body: { email_address: @user.email, status: 'subscribed', merge_fields: { FNAME: @user.first_name, LNAME: @user.last_name } })
      else
        @gibbon.lists(@audience_id).members.create(body: { email_address: @user.email, status: 'unsubscribed', merge_fields: { FNAME: @user.first_name, LNAME: @user.last_name } })
      end
    end
  end
end
