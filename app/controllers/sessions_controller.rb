class SessionsController < ApplicationController
  before_action :set_session, only: %i[show update destroy]

  def show
    @review = Review.new
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
    @conversation = Conversation.new
  end

  def create
    @session = Session.new(session_params)
    authorize @session
    service = Service.find(params[:service_id])
    @session.primary_time = @session.primary_time - @session.primary_time.in_time_zone(current_user.timezone).utc_offset
    @session.secondary_time = @session.secondary_time - @session.secondary_time.in_time_zone(current_user.timezone).utc_offset
    @session.tertiary_time = @session.tertiary_time - @session.tertiary_time.in_time_zone(current_user.timezone).utc_offset
    @session.update(duration: service.duration, status: 'pending', paid: false, service: service, amount: service.price * 1.03, user: current_user)
    if @session.save
      payment_session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: [{
          name: service.name,
          amount: (service.price_cents * 1.03).to_i,
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
      if @session.update(start_time: @start_time, status: 'confirmed')
        Notification.create(recipient: @session.user, actor: current_user, action: 'has confirmed your session', notifiable: @session)
        redirect_to user_sessions_path(current_user), notice: 'Session request accepted'
        SessionMailer.with(session: @session).confirm_practitioner.deliver_now
        SessionMailer.with(session: @session).confirm_user.deliver_now
      else

      end
    elsif params[:commit] == 'Decline'
      @session.update!(status: 'declined')
      Notification.create(recipient: @session.user, actor: current_user, action: 'has declined your session', notifiable: @session)
      redirect_to user_sessions_path(current_user), notice: 'Session request declined'
    elsif params[:commit] == 'Cancel this session'
      @session.update(status: 'cancelled')
      if @session.user == current_user
        Notification.create(recipient: @session.practitoner.user, actor: current_user, action: 'has cancelled your session', notifiable: @session)
      else
        Notification.create(recipient: @session.user, actor: current_user, action: 'has cancelled your session', notifiable: @session)
      end
      redirect_to user_sessions_path(current_user), notice: 'Session cancelled'
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
    params.require(:session).permit(:start_time, :duration, :primary_time, :secondary_time, :tertiary_time, :amount, :paid, :link, :status)
  end
end
