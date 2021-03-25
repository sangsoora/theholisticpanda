class SessionsController < ApplicationController
  before_action :set_session, only: %i[show update destroy]

  def show
    @review = Review.new
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
    @conversation = Conversation.new
    if @session.service.default_service
      @practitioner = Practitioner.find(@session.free_practitioner_id)
    else
      @practitioner = @session.practitioner
    end
    if @session.start_time
      session_time = @session.start_time.in_time_zone(current_user.timezone)
      current_time = Time.current.in_time_zone(current_user.timezone)
      @time_diff = ((session_time - current_time) / 1.hour).round
    end
  end

  def create
    @session = Session.new(session_params)
    authorize @session
    service = Service.find(params[:service_id])
    @session.primary_time = @session.primary_time - @session.primary_time.in_time_zone(current_user.timezone).utc_offset
    @session.secondary_time = @session.secondary_time - @session.secondary_time.in_time_zone(current_user.timezone).utc_offset
    @session.tertiary_time = @session.tertiary_time - @session.tertiary_time.in_time_zone(current_user.timezone).utc_offset
    if params[:commit] == 'Send Discovery Call Request'
      @session.update(duration: service.duration, session_type: service.service_type, status: 'pending', paid: false, service: service, amount: service.price, user: current_user, free_practitioner_id: params[:session][:practitioner])
      if @session.save
        @practitioner = Practitioner.find(params[:session][:practitioner])
        SessionMailer.with(session: @session).send_request.deliver_now
        Notification.create(recipient: @practitioner.user, actor: current_user, action: 'sent you a discovery call request', notifiable: @session)
        redirect_to practitioner_path(@practitioner), notice: 'Your request has been sent'
      else
        render :new
      end
    else
      @session.update(duration: service.duration, session_type: service_type, status: 'pending', paid: false, service: service, amount: service.price, user: current_user)
      if @session.save
        payment_session = Stripe::Checkout::Session.create(
          billing_address_collection: 'required',
          payment_method_types: ['card'],
          line_items: [{
            name: service.name,
            amount: service.price_cents.to_i,
            currency: 'cad',
            quantity: 1
          }],
          success_url: session_url(@session),
          cancel_url: session_url(@session)
        )
        @session.update(checkout_session_id: payment_session.id)
        redirect_to new_session_payment_path(@session)
      else
        render :new
      end
    end
  end

  def edit
  end

  def update
    if params[:commit] == 'Confirm'
      if params[:session][:time] == 'primary'
        @start_time = @session.primary_time
      elsif params[:session][:time] == 'secondary'
        @start_time = @session.secondary_time
      elsif params[:session][:time] == 'tertiary'
        @start_time = @session.tertiary_time
      end
      if @session.update(session_params)
        @session.update(start_time: @start_time, status: 'confirmed')
        if @session.link && !@session.link.start_with?('http://', 'https://')
          @session.update(link: 'http://' + @session.link)
        end
        Notification.create(recipient: @session.user, actor: current_user, action: 'has confirmed your session', notifiable: @session)
        SessionMailer.with(session: @session).confirm_practitioner.deliver_now
        SessionMailer.with(session: @session).confirm_user.deliver_now
        redirect_to practitioner_sessions_path, notice: 'Session request accepted.'
      end
    elsif params[:commit] == 'Decline'
      @session.update!(status: 'declined')
      Notification.create(recipient: @session.user, actor: current_user, action: 'has declined your session', notifiable: @session)
      SessionMailer.with(session: @session).decline_request.deliver_now
      redirect_to practitioner_sessions_path, notice: 'Session request declined.'
    elsif params[:commit] == 'Confirm Cancellation'
      @session.update(status: 'cancelled', cancelled_user: current_user)
      if @session.service.default_service
        @practitioner = Practitioner.find(@session.free_practitioner_id)
      else
        @practitioner = @session.practitioner
      end
      SessionMailer.with(session: @session).cancel_practitioner.deliver_now
      SessionMailer.with(session: @session).cancel_user.deliver_now
      if @session.user == current_user
        Notification.create(recipient: @practitioner.user, actor: current_user, action: 'has cancelled your session', notifiable: @session)
        redirect_to user_sessions_path, notice: 'Session cancelled.'
      else
        Notification.create(recipient: @session.user, actor: current_user, action: 'has cancelled your session', notifiable: @session)
        redirect_to practitioner_sessions_path, notice: 'Session cancelled.'
      end
    else
      @param = session_params
      if (params[:session].keys.length == 1) && (params[:session][:link]) && (params[:session][:link] != '')
        if params[:session][:link].start_with?('http://', 'https://')
          @session.update(link: params[:session][:link])
        else
          @session.update(link: 'http://' + params[:session][:link])
        end
        Notification.create(recipient: @session.user, actor: current_user, action: 'has updated virtual session link', notifiable: @session)
        SessionMailer.with(session: @session).change_link.deliver_now
      elsif (params[:session].keys.length == 3) && (params[:session][:address]) && (params[:session][:address] != '')
        @session.update(address: params[:session][:address], latitude: params[:session][:latitude], longitude: params[:session][:longitude])
        Notification.create(recipient: @session.user, actor: current_user, action: 'has updated session location', notifiable: @session)
        SessionMailer.with(session: @session).change_address.deliver_now
      end
      respond_to do |format|
        format.html { redirect_to session_path(@session) }
        format.js
      end
    end
  end

  def destroy
  end

  private

  def set_session
    @session = Session.find(params[:id])
    authorize @session
  end

  def session_params
    params.require(:session).permit(:start_time, :duration, :session_type, :primary_time, :secondary_time, :tertiary_time, :message, :amount, :paid, :link, :status, :cancel_reason, :cancelled_user, :address, :latitude, :longitude)
  end
end
