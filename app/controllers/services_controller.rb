class ServicesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_service, only: [:show, :update, :destroy]

  def index
    @services = policy_scope(Service)
    if params[:search]
      if params[:search][:specialty]
        if params[:search][:specialty].count == 2
          @services_by_specialty = Service.filter_by_specialty(params[:search][:specialty][0])
        elsif params[:search][:specialty].count > 2
          @services_by_specialty = params[:search][:specialty].reject(&:blank?).map do |keyword|
            Service.filter_by_specialty(keyword)
          end
          @services_by_specialty.flatten!
        elsif params[:search][:specialty].count == 1
          @services_by_specialty = []
        end
      else
        @services_by_specialty = []
      end
      if params[:search][:condition]
        if params[:search][:condition].count == 2
          @services_by_condition = Service.filter_by_condition(params[:search][:condition][0])
        elsif params[:search][:condition].count > 2
          @services_by_condition = params[:search][:condition].reject(&:blank?).map do |keyword|
            Service.filter_by_condition(keyword)
          end
          @services_by_condition.flatten!
        elsif params[:search][:condition].count == 1
          @services_by_condition = []
        end
      else
        @services_by_condition = []
      end
      if params[:search][:language]
        if params[:search][:language].count == 2
          @services_by_language = Service.filter_by_language(params[:search][:language][0])
        elsif params[:search][:language].count > 2
          @services_by_language = params[:search][:language].reject(&:blank?).map do |keyword|
            Service.filter_by_language(keyword)
          end
          @services_by_language.flatten!
        elsif params[:search][:language].count == 1
          @services_by_language = []
        end
      else
        @services_by_language = []
      end
      if params[:search][:service_type]
        if params[:search][:service_type].present?
          @services_by_service_type = Service.filter_by_service_type(params[:search][:service_type].split(' ')[0].downcase)
        else
          @services_by_service_type = []
        end
      else
        @services_by_service_type = []
      end
      if @services_by_specialty == [] && @services_by_condition == [] && @services_by_language == []
        @filtered_services = @services_by_service_type.uniq.compact.sort_by(&:id)
      elsif @services_by_specialty == [] && @services_by_condition == [] && @services_by_service_type == []
        @filtered_services = @services_by_language.uniq.compact.sort_by(&:id)
      elsif @services_by_specialty == [] && @services_by_language == [] && @services_by_service_type == []
        @filtered_services = @services_by_condition.uniq.compact.sort_by(&:id)
      elsif @services_by_condition == [] && @services_by_language == [] && @services_by_service_type == []
        @filtered_services = @services_by_specialty.uniq.compact.sort_by(&:id)
      elsif @services_by_specialty == [] && @services_by_service_type == []
        @filtered_services = (@services_by_condition & @services_by_language).uniq.compact.sort_by(&:id)
      elsif @services_by_condition == [] && @services_by_service_type == []
        @filtered_services = (@services_by_specialty & @services_by_language).uniq.compact.sort_by(&:id)
      elsif @services_by_specialty == [] && @services_by_language == []
        @filtered_services = (@services_by_condition & @services_by_service_type).uniq.compact.sort_by(&:id)
      elsif @services_by_condition == [] && @services_by_language == []
        @filtered_services = (@services_by_specialty & @services_by_service_type).uniq.compact.sort_by(&:id)
      elsif @services_by_specialty == [] && @services_by_condition == []
        @filtered_services = (@services_by_language & @services_by_service_type).uniq.compact.sort_by(&:id)
      elsif @services_by_specialty == []
        @filtered_services = (@services_by_condition & @services_by_language & @services_by_service_type).uniq.compact.sort_by(&:id)
      elsif @services_by_condition == []
        @filtered_services = (@services_by_specialty & @services_by_language & @services_by_service_type).uniq.compact.sort_by(&:id)
      end
      @grouped_services = @filtered_services.group_by { |service| service.practitioner }
    end
  end

  def show
    @session = Session.new
  end

  def create
    @service = Service.new(service_params)
    authorize @service
    @practitioner_specialty = PractitionerSpecialty.find(params[:practitioner_specialty_id])
    @service.practitioner_specialty = @practitioner_specialty
    if @service.save!
      redirect_to service_path(@service)
    else
      render :new
    end
  end

  def update
  end

  def destroy
  end

  private

  def set_service
    @service = Service.find(params[:id])
    authorize @service
  end

  def service_params
    params.require(:service).permit(:name, :description, :service_type, :price, :duration)
  end
end
