class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :update, :destroy]

  def show
  end

  def create
    @session = Session.new(session_params)
    authorize @session
    @session.status = 'pending'
    @session.paid = false;
    @session.service = Service.find(params[:service_id])
    @session.user = current_user
    if @session.save
      redirect_to session_path(@session)
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_session
    @session = Session.find(params[:id])
    authorize @session
  end

  def session_params
    params.require(:session).permit(:start_time, :end_time, :total_price, :paid, :status)
  end
end
