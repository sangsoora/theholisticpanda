class WorkingHoursController < ApplicationController
  before_action :set_working_hour, only: %i[update destroy]

  def create
    @working_hour = WorkingHour.new(working_hour_params)
    authorize @working_hour
    @practitioner = Practitioner.find(params[:practitioner_id])
    @working_hour.practitioner = @practitioner
    @working_hour.save!
  end

  def update
    if @working_hour.update(working_hour_params)
      @param = working_hour_params
      @practitioner = @working_hour.practitioner
      respond_to do |format|
        format.html { redirect_to practitioner_profile_path }
        format.js
      end
    end
  end

  def destroy
    @practitioner = @working_hour.practitioner
    @num = @working_hour.day
    @working_hour.update(opens: nil, closes: nil)
    respond_to do |format|
      format.html { redirect_to practitioner_profile_path }
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
