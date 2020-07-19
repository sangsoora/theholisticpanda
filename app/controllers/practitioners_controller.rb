class PractitionersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_practitioner, only: [:show, :update, :destroy]

  def index
    @practitioners = policy_scope(Practitioner)
    if params[:search]
      if params[:search][:education].count == 2
        @practitioners_by_education = Practitioner.filter_by_education(params[:search][:education][1])
      elsif params[:search][:education].count > 2
        @practitioners_by_education = params[:search][:education].drop(1).map do |keyword|
          Practitioner.filter_by_education(keyword)
        end
        @practitioners_by_education = @practitioners_by_education.map { |practitioners| practitioners.first }
      elsif params[:search][:education].count == 1
        @practitioners_by_education = []
      end
      if params[:search][:specialty].count == 2
        @practitioners_by_specialty = Practitioner.filter_by_specialty(params[:search][:specialty][1])
      elsif params[:search][:specialty].count > 2
        @practitioners_by_specialty = params[:search][:specialty].drop(1).map do |keyword|
          Practitioner.filter_by_specialty(keyword)
        end
        @practitioners_by_specialty = @practitioners_by_specialty.map { |practitioners| practitioners.first }
      elsif params[:search][:specialty].count == 1
        @practitioners_by_specialty = []
      end
      if params[:search][:condition].count == 2
        @practitioners_by_condition = Practitioner.filter_by_condition(params[:search][:condition][1])
      elsif params[:search][:condition].count > 2
        @practitioners_by_condition = params[:search][:condition].drop(1).map do |keyword|
          Practitioner.filter_by_condition(keyword)
        end
        @practitioners_by_condition = @practitioners_by_condition.map { |practitioners| practitioners.first }
      elsif params[:search][:condition].count == 1
        @practitioners_by_condition = []
      end
      if params[:search][:language].count == 2
        @practitioners_by_language = Practitioner.filter_by_language(params[:search][:language][1])
      elsif params[:search][:language].count > 2
        @practitioners_by_language = params[:search][:language].drop(1).map do |keyword|
          Practitioner.filter_by_language(keyword)
        end
        @practitioners_by_language = @practitioners_by_language.map { |practitioners| practitioners.first }
      elsif params[:search][:language].count == 1
        @practitioners_by_language = []
      end
      if params[:search][:service_type].present?
        @practitioners_by_service_type = Practitioner.filter_by_service_type(params[:search][:service_type].split(' ')[0].downcase)
      else
        @practitioners_by_service_type = []
      end
      @filtered_practitioners = (@practitioners_by_education + @practitioners_by_specialty + @practitioners_by_condition + @practitioners_by_language + @practitioners_by_service_type).uniq.compact.sort_by(&:id)
    end
  end

  def show
  end

  def new
    @practitioner = Practitioner.new
    authorize @practitioner
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
    params.require(:practitioner).permit(:location, :address, :bio, :video, :latitude, :longitude, :education, :experience)
  end
end
