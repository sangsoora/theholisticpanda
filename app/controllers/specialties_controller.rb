class SpecialtiesController < ApplicationController
  before_action :set_specialty, only: [:destroy]

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

  private

  def set_specialty
    @specialty = Specialty.find(params[:id])
    authorize @specialty
  end

  def specialty_params
    params.require(:specialty).permit(:name)
  end
end
