class PractitionerSpecialtiesController < ApplicationController
  before_action :set_practitioner_specialty, only: [:destroy]

  def create
    @practitioner_specialty = PractitionerSpecialty.new
    authorize @practitioner_specialty
    @practitioner = Practitioner.find(params[:practitioner_id])
    @specialties = Specialty.all.sort_by(&:name)
    @practitioner_specialty.practitioner = @practitioner
    @practitioner_specialty.specialty = Specialty.find(params[:practitioner][:specialty_id])
    @practitioner_specialty.save!
    redirect_to practitioner_profile_path(Practitioner.find(params[:practitioner_id]))
  end

  def destroy
    @practitioner_specialty.destroy
    @specialty = @practitioner_specialty.specialty
    redirect_to practitioner_profile_path(@practitioner_specialty.practitioner)
  end

  private

  def set_practitioner_specialty
    @practitioner_specialty = PractitionerSpecialty.find(params[:id])
    authorize @practitioner_specialty
  end
end
