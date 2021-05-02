class StripeCheckoutSessionService
  def call(event)
    if Practitioner.find_by(checkout_session_id: event.data.object.id)
      @practitioner = Practitioner.find_by(checkout_session_id: event.data.object.id)
      @practitioner.update!(payment_status: 'paid')
      PractitionerMailer.with(practitioner: @practitioner).welcome.deliver_now
      AdminMailer.with(practitioner: @practitioner).new_practitioner.deliver_now
      if @practitioner.country_code == 'CA'
        raw_token = RestClient::Request.execute(method: :post, url: 'https://api.screeningcanada.com//connect/token', payload: { grant_type: 'client_credentials', client_id: ENV["MODO_LIVE_API_KEY"], client_secret: ENV["MODO_LIVE_API_SECRET"], scope: 'files.manage' })
        token_type = JSON.parse(raw_token.body)["token_type"]
        token = JSON.parse(raw_token.body)["access_token"]
        payload = { 'candidate' => { 'firstName' => @practitioner.user.first_name, 'lastName' => @practitioner.user.last_name, 'contactInfo' => { 'email' => @practitioner.user.email, 'phone' => @practitioner.user.phone_number}, 'redirectUrl'=> 'www.theholisticpanda.com' }, 'searches' => [{ 'id' => 'cpcs' }],'sendCandidateEmail' => true, 'skipLandingPage' => true, 'lockProfile' => false, 'searchReasonId' => 'contracting', 'candidatePaid' => false, 'invitationInstructions' => 'Please upload your educational credentials/certifications for future verification.' }
        response = RestClient.post 'https://api.screeningcanada.com/v1.1/files', payload.to_json, { content_type: 'application/json', accept: '*/*', Authorization: "#{token_type} #{token}" }
        id = JSON.parse(response.body)['id']
        @practitioner.update(background_check_id: id, background_check_status: 'pending')
      end
    # elsif Session.find_by(checkout_session_id: event.data.object.id)
    #   @session = Session.find_by(checkout_session_id: event.data.object.id)
    #   @session.update!(status: 'pending', paid: true)
    #   SessionMailer.with(session: @session).send_request.deliver_now
    #   Notification.create(recipient: @session.practitioner.user, actor: current_user, action: 'sent you a session request', notifiable: @session)
    end
  end
end
