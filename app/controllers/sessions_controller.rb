class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :update, :destroy]

  def show
  end

  def create
    @session = Session.new(session_params)
    authorize @session

    service = Service.find(params[:service_id])
    @session.duration = service.duration
    @session.status = 'pending'
    @session.paid = false
    @session.service = service
    @session.amount = service.price * 1.03
    @session.user = current_user
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
        @session.update!(start_time: @session.primary_time, status: 'confirmed')
      elsif params[:session][:time] == 'secondary'
        @session.update!(start_time: @session.secondary_time, status: 'confirmed')
      elsif params[:session][:time] == 'tertiary'
        @session.update!(start_time: @session.tertiary_time, status: 'confirmed')
      end
      raise
      redirect_to user_sessions_path(current_user), notice: 'Session request accepted'
    elsif params[:commit] == 'Decline'
      redirect_to user_sessions_path(current_user), notice: 'Session request declined'
    elsif params[:commit] == 'Cancel this session'
      @session.update(status: 'cancelled')
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
    params.require(:session).permit(:start_time, :duration, :primary_time, :secondary_time, :tertiary_time, :amount, :paid, :status)
  end
end
