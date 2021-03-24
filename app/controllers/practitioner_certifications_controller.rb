class PractitionerCertificationsController < ApplicationController
  before_action :set_practitioner_certification, only: [:destroy]

  def create
    @practitioner_certification = PractitionerCertification.new(practitioner_certification_params)
    authorize @practitioner_certification
    @practitioner = Practitioner.find(params[:practitioner_id].split('_').last.to_i)
    @practitioner_certification.practitioner = @practitioner
    if @practitioner_certification.save!
      respond_to do |format|
        format.html { redirect_to practitioner_profile_path }
        format.js
      end
    end
  end

  def destroy
    @practitioner = @practitioner_certification.practitioner
    @practitioner_certification.destroy
    respond_to do |format|
      format.html { redirect_to practitioner_profile_path }
      format.js
    end
  end

  private

  def set_practitioner_certification
    @practitioner_certification = PractitionerCertification.find(params[:id])
    authorize @practitioner_certification
  end

  def practitioner_certification_params
    params.require(:practitioner_certification).permit(:certification_type, :name)
  end
end
