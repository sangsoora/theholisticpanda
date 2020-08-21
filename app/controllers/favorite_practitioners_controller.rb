class FavoritePractitionersController < ApplicationController
  before_action :set_favorite_practitioner, only: [:destroy]

  def create
    @favorite_practitioner = FavoritePractitioner.new
    authorize @favorite_practitioner
    @practitioner = Practitioner.find(params[:practitioner_id])
    @favorite_practitioner.practitioner = @practitioner
    @favorite_practitioner.user = current_user
    @favorite_practitioner.save!
    redirect_to practitioner_path(@practitioner)
  end

  def destroy
    @favorite_practitioner.destroy
    redirect_to practitioner_path(@favorite_practitioner.practitioner)
  end

  private

  def set_favorite_practitioner
    @favorite_practitioner = FavoritePractitioner.find(params[:id])
    authorize @favorite_practitioner
  end
end
