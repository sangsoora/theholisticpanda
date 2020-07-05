class ServicesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_service, only: [:show, :update, :destroy]

  def show
    @session = Session.new
  end

  def create

  end

  def update

  end

  def destroy

  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :description, :service_type, :price, :duration)
  end
end
