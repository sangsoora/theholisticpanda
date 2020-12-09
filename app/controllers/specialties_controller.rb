class SpecialtiesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show filter]
  before_action :set_specialty, only: %i[show destroy]

  def show
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

  def specialty_params
    params.require(:specialty).permit(:name)
  end
end
