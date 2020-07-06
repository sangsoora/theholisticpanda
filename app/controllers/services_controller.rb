class ServicesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_service, only: [:show, :update, :destroy]

  def show
    @session = Session.new
  end

  def create
    @service = Service.new(service_params)
    authorize @service
    @practitioner_specialty = PractitionerSpecialty.find(params[:practitioner_specialty_id])
    @service.practitioner_specialty = @practitioner_specialty
    if @service.save!
      redirect_to service_path(@service)
    else
      render :new
    end
  end

  def update

  end

  def destroy

  end

  private

  def set_service
    @service = Service.find(params[:id])
    authorize @service
  end

  def service_params
    params.require(:service).permit(:name, :description, :service_type, :price, :duration)
  end
end
