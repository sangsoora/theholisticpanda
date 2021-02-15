class PractitionerMembershipsController < ApplicationController
  before_action :set_practitioner_membership, only: [:destroy]

  def create
    @practitioner_membership = PractitionerMembership.new(practitioner_membership_params)
    authorize @practitioner_membership
    @practitioner = Practitioner.find(params[:practitioner_id])
    @practitioner_membership.practitioner = @practitioner
    if @practitioner_membership.save!
      respond_to do |format|
        format.html { redirect_to practitioner_profile_path }
        format.js
      end
    end
  end

  def destroy
    @practitioner = @practitioner_membership.practitioner
    @practitioner_membership.destroy
    respond_to do |format|
      format.html { redirect_to practitioner_profile_path }
      format.js
    end
  end

  private

  def set_practitioner_membership
    @practitioner_membership = PractitionerMembership.find(params[:id])
    authorize @practitioner_membership
  end

  def practitioner_membership_params
    params.require(:practitioner_membership).permit(:name)
  end
end
