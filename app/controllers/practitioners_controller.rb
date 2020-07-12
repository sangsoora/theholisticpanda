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
      @filtered_practitioners = (@practitioners_by_education + @practitioners_by_specialty).uniq.compact
      # if params[:search][:education].count == 2
      #   @practitioners_by_education = Practitioner.filter_by_education(params[:search][:education][1]) if params[:search][:education].present?
      # elsif params[:search][:education].count > 2
      #   @practitioners_by_education = params[:search][:education].drop(1).map do |keyword|
      #     Practitioner.filter_by_education(keyword)
      #   end
      # end
      # if params[:search][:education].count == 2
      #   @practitioners_by_education = Practitioner.filter_by_education(params[:search][:education][1]) if params[:search][:education].present?
      # elsif params[:search][:education].count > 2
      #   @practitioners_by_education = params[:search][:education].drop(1).map do |keyword|
      #     Practitioner.filter_by_education(keyword)
      #   end
      # end
    end
  end

  def show
  end

  def new
    @practitioner = Practitioner.new
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
