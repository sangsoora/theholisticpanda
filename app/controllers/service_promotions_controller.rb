class ServicePromotionsController < ApplicationController
  before_action :set_service_promotion, only: %i[update destroy]

  def create
    @service_promotion = ServicePromotion.new(service_promotion_params)
    authorize @service_promotion
    @service_promotion.service = Service.find(params[:service_id])
    if @service_promotion.save
      flash[:notice] = 'Service promotion has been created.'
      redirect_to practitioner_services_path
    else
      redirect_to practitioner_services_path
    end
  end

  def update
    if @service_promotion.update(service_promotion_params)
      flash[:notice] = 'Service promotion has been successfully updated!'
    else
      flash[:alert] = 'Something went wrong!'
    end
    redirect_to practitioner_services_path
  end

  def destroy
    @service_promotion.destroy
    redirect_to practitioner_services_path
  end

  private

  def set_service_promotion
    @service_promotion = ServicePromotion.find(params[:id])
    authorize @service_promotion
  end

  def service_promotion_params
    params.require(:service_promotion).permit(:start_date, :end_date, :discount_percentage)
  end
end
