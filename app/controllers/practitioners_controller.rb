class PractitionersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_practitioner, only: [:show, :update, :destroy]

  def show
  end

  def create
    @practitioner = Practitioner.new(practitioner_params)
    authorize @practitioner
    @practitioner.user = current_user
    if @practitioner.save
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    if @practitioner.update(practitioner_params)
      redirect_to practitioner_path(@practitioner)
    else
      render :edit
    end
  end

  def destroy
    @practitioner.destroy
    redirect_to root_path
  end

  private

  def set_practitioner
    @practitioner = Practitioner.find(params[:id])
    authorize @practitioner
  end

  def practitioner_params
    params.require(:practitioner).permit(:location, :address, :bio, :video, :latitude, :longitude)
  end
end
