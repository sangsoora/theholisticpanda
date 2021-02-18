class StripeCheckoutSessionService
  def call(event)
    if Practitioner.find_by(checkout_session_id: event.data.object.id)
      @practitioner = Practitioner.find_by(checkout_session_id: event.data.object.id)
      @practitioner.update!(payment_status: 'paid')
      PractitionerMailer.with(practitioner: @practitioner).welcome.deliver_now
      AdminMailer.with(practitioner: @practitioner).new_practitioner.deliver_now
      # payload = { 'candidate' => { 'firstName' => @practitioner.user.first_name, 'lastName' => @practitioner.user.last_name, 'contactInfo' => { 'email' => @practitioner.user.email, 'phone' => @practitioner.user.phone_number}, 'redirectUrl'=> 'www.theholisticpanda.com' }, 'searches' => [{ 'id' => 'epic' }],'sendCandidateEmail' => true, 'skipLandingPage' => false, 'lockProfile' => false, 'searchReasonId' => 'contracting', 'candidatePaid' => false, 'invitationInstructions' => 'Welcome' }
      # response = RestClient.post 'https://testapi.screeningcanada.com/v1.1/files', payload.to_json, { content_type: 'application/json', accept: '*/*', Authorization: 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJmZTMzNWRmYS1mN2IwLTRlOGQtODYxOC05YWRmN2NlNGRjMGYiLCJ1c2VybmFtZSI6IkFwaSBDbGllbnQiLCJwIjoiMCIsImNsaWVudElkIjoiNjJmOTkzZDgtNjkyOS00NDRiLTkwZTAtNGYzYTNlYmEyZjY2IiwidG9rZW5fdXNhZ2UiOiJhY2Nlc3NfdG9rZW4iLCJqdGkiOiIwYWVmMGQ0OS0yNTY0LTQyMDItODlhZS1hYjc1N2FhYzI2ZjAiLCJjZmRfbHZsIjoicHJpdmF0ZSIsImF1ZCI6Imh0dHBzOi8vdGVzdGFwaS5zY3JlZW5pbmdjYW5hZGEuY29tLyIsImF6cCI6ImZlMzM1ZGZhLWY3YjAtNGU4ZC04NjE4LTlhZGY3Y2U0ZGMwZiIsIm5iZiI6MTYxMzY2NjE0MywiZXhwIjoxNjEzNjY5NzQzLCJpYXQiOjE2MTM2NjYxNDMsImlzcyI6Imh0dHA6Ly9zYW5kYm94YXBpLnNjcmVlbmluZ2NhbmFkYS5jb20vIn0.PE9VEIy9qhvuZ6jYBI-ycaumWCQxDVgPHcY6WcW_RNo' }
      # id = JSON.parse(response.body)['id']
      # @practitioner.update(background_check_id: id, background_check_status: 'pending')
    elsif Session.find_by(checkout_session_id: event.data.object.id)
      @session = Session.find_by(checkout_session_id: event.data.object.id)
      @session.update!(status: 'pending', paid: true)
      SessionMailer.with(session: @session).send_request.deliver_now
      Notification.create(recipient: @session.practitioner.user, actor: current_user, action: 'sent you a session request', notifiable: @session)
    end
  end
end
