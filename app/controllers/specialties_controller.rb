class SpecialtiesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show filter]
  before_action :set_specialty, only: %i[show destroy]
  before_action :set_notifications, only: [:show]

  def show
    @specialty_services = @specialty.services.active_services
  end

  def create
    @specialty = Specialty.new(specialty_params)
    authorize @specialty
    if @specialty.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    @specialty.destroy
    redirect_to root_path
  end

  def filter
    @specialties = Specialty.where("name ILIKE ?", "%#{params[:query]}%")
    authorize @specialties
  end

  private

  def set_specialty
    @specialty = Specialty.find(params[:id])
    authorize @specialty
  end

  def set_notifications
    @notifications = Notification.includes(:actor).where(recipient: current_user).order('created_at DESC').unread
  end

  def specialty_params
    params.require(:specialty).permit(:name, :description, :risk)
  end
end
