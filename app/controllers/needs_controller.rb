class NeedsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_need, only: [:show]
  before_action :set_notifications, only: [:show]

  def show

  end

  private

  def set_need
    @need = Need.includes(:recipient, :messages).find(params[:id])
    authorize @need
  end
end
