class PaymentsController < ApplicationController
  def new
    @session = current_user.sessions.where(status: 'pending').find(params[:session_id])
    authorize @session
  end
end
