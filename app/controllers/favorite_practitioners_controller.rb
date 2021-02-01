class FavoritePractitionersController < ApplicationController
  before_action :set_favorite_practitioner, only: [:destroy]

  def create
    @favorite_practitioner = FavoritePractitioner.new
    authorize @favorite_practitioner
    @practitioner = Practitioner.find(params[:practitioner_id])
    @favorite_practitioner.practitioner = @practitioner
    @favorite_practitioner.user = current_user
    @favorite_practitioner.save!
    respond_to do |format|
      format.html { redirect_to practitioner_path(@practitioner) }
      format.js
    end
  end

  def destroy
    @favorite_practitioner.destroy
    @practitioner = @favorite_practitioner.practitioner
    @favorite_practitioners = current_user.favorite_practitioners.includes(practitioner: :user)
    respond_to do |format|
      format.html { redirect_to practitioner_path(@practitioner) }
      format.js
    end
  end

  private

  def set_favorite_practitioner
    @favorite_practitioner = FavoritePractitioner.find(params[:id])
    authorize @favorite_practitioner
  end
end
