class FavoriteServicesController < ApplicationController
  before_action :set_favorite_service, only: [:destroy]

  def create
    @favorite_service = FavoriteService.new
    authorize @favorite_service
    @service = Service.find(params[:service_id])
    @favorite_service.service = @service
    @favorite_service.user = current_user
    @favorite_service.save!
    # You will most certainly know that params are available in 'params' hash
    respond_to do |format|
      format.html { redirect_to service_path(@service) }
      format.js
    end
  end

  def destroy
    @favorite_service.destroy
    @service = @favorite_service.service
    respond_to do |format|
      format.html { redirect_to service_path(@service) }
      format.js
    end
  end

  private

  def set_favorite_service
    @favorite_service = FavoriteService.find(params[:id])
    authorize @favorite_service
  end
end
