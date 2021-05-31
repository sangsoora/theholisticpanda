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
      @time_diff = ((session_time - current_time) / 1.hour)
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
        if current_user.payment_methods.count == 0
          if !current_user.stripe_id
            customer = Stripe::Customer.create({
              email: current_user.email,
              name: current_user.full_name,
              phone: current_user.phone_number
            })
            current_user.update(stripe_id: customer.id)
          end
          setup_session = Stripe::Checkout::Session.create(
            payment_method_types: ['card'],
            mode: 'setup',
            customer: current_user.stripe_id,
            billing_address_collection: 'required',
            success_url: new_session_payment_url(@session),
            cancel_url: new_session_payment_url(@session)
          )
          current_user.update(setup_session_id: setup_session.id)
          redirect_to user_payment_path
        else
          redirect_to new_session_payment_path(@session)
        end
      else
        render :new
      end
    end
  end

  def edit
  end

  def update
    if params[:commit] == 'Confirm payment method'
      if @session.update(session_params)
        UserPromo.find(params[:session][:promo_id]).update(active: false) if params[:session][:promo_id]
        @session.update!(status: 'pending')
        SessionMailer.with(session: @session).send_request.deliver_now
        Notification.create(recipient: @session.practitioner.user, actor: current_user, action: 'sent you a session request', notifiable: @session)
        redirect_to session_path(@session)
      else
        redirect_to new_session_payment_path(@session)
      end
    elsif params[:commit] == 'Confirm'
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
      UserPromo.find(@session.promo_id).update(active: true) if @session.promo_id
      @session.update!(status: 'declined')
      Notification.create(recipient: @session.user, actor: current_user, action: 'has declined your session', notifiable: @session)
      SessionMailer.with(session: @session).decline_request.deliver_now
      redirect_to practitioner_sessions_path, notice: 'Session request declined.'
    elsif params[:commit] == 'Charge'
      @session.update(session_params)
      redirect_to practitioner_sessions_path, notice: 'Session payment has been charged.'
    elsif params[:commit] == 'Confirm cancellation'
      @session.update(status: 'cancelled', cancelled_user: current_user)
      session_time = @session.start_time.in_time_zone(current_user.timezone)
      current_time = Time.current.in_time_zone(current_user.timezone)
      time_diff = ((session_time - current_time) / 1.hour)
      if @session.service.default_service
        @practitioner = Practitioner.find(@session.free_practitioner_id)
        SessionMailer.with(session: @session).cancel_practitioner.deliver_now
        SessionMailer.with(session: @session).cancel_user.deliver_now
      else
        @practitioner = @session.practitioner
        if time_diff >= 24
          UserPromo.find(@session.promo_id).update(active: true) if @session.promo_id
          SessionMailer.with(session: @session).cancel_practitioner.deliver_now
          SessionMailer.with(session: @session).cancel_user.deliver_now
        else
          if @session.cancelled_user == @practitioner.user
            SessionMailer.with(session: @session).cancel_practitioner_within_24.deliver_now
            SessionMailer.with(session: @session).cancel_user.deliver_now
          else
            SessionMailer.with(session: @session).cancel_practitioner.deliver_now
            SessionMailer.with(session: @session).cancel_user_within_24.deliver_now
          end
        end
      end
      if @session.user == current_user
        Notification.create(recipient: @practitioner.user, actor: current_user, action: 'has cancelled a session with you', notifiable: @session)
        redirect_to user_sessions_path, notice: 'Session cancelled.'
      else
        Notification.create(recipient: @session.user, actor: current_user, action: 'has cancelled a session with you', notifiable: @session)
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
      else
        @session.update(session_params)
      end
      respond_to do |format|
        format.html { redirect_to session_path(@session) }
        format.js
      end
    end
  end

  def destroy
    UserPromo.find(@session.promo_id).update(active: true) if @session.promo_id
    @session.destroy
    redirect_to user_sessions_path, notice: 'Session request cancelled.'
  end

  private

  def set_session
    @session = Session.find(params[:id])
    authorize @session
  end

  def session_params
    params.require(:session).permit(:start_time, :duration, :session_type, :primary_time, :secondary_time, :tertiary_time, :message, :amount, :paid, :link, :status, :cancel_reason, :cancelled_user, :address, :latitude, :longitude, :payment_method_id, :estimate_price, :promo_id, :discount_price, :tax_price, :estimate_price)
  end
end
