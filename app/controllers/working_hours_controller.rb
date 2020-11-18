class WorkingHoursController < ApplicationController
  before_action :set_working_hour, only: [:destroy]

  def create
    @working_hour = WorkingHour.new(working_hour_params)
    authorize @working_hour
    @practitioner = Practitioner.find(params[:practitioner_id])
    @working_hour.practitioner = @practitioner
    if @working_hour.save!
      respond_to do |format|
        format.html { redirect_to practitioner_profile_path(@practitioner) }
        format.js
      end
    end
  end

  def destroy
    @practitioner = @working_hour.practitioner
    @working_hour.destroy
    respond_to do |format|
      format.html { redirect_to practitioner_profile_path(@practitioner) }
      format.js
    end
  end

  private

  def set_working_hour
    @working_hour = WorkingHour.find(params[:id])
    authorize @working_hour
  end

  def working_hour_params
    params.require(:working_hour).permit(:day, :opens, :closes)
  end
end
