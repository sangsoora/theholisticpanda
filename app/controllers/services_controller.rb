class ServicesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_notifications, only: [:index, :show]
  before_action :set_service, only: [:show, :update, :destroy]

  def index
    @services = policy_scope(Service).includes(:specialty, :practitioner_specialty, :languages, practitioner: [:user, :photo_attachment]).group_by { |service| service.specialty }
    @services = @services.sort_by {|k, v| k[:name] }.to_h
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
      if params[:search][:health_goal]
        if params[:search][:health_goal].count == 2
          @services_by_health_goal = Service.filter_by_health_goal(params[:search][:health_goal][0])
        elsif params[:search][:health_goal].count > 2
          @services_by_health_goal = params[:search][:health_goal].reject(&:blank?).map do |keyword|
            Service.filter_by_health_goal(keyword)
          end
          @services_by_health_goal.flatten!
        elsif params[:search][:health_goal].count == 1
          @services_by_health_goal = []
        end
      else
        @services_by_health_goal = []
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
          @services_by_service_type = Service.filter_by_service_type(params[:search][:service_type].split(' ')[0])
        else
          @services_by_service_type = []
        end
      else
        @services_by_service_type = []
      end
      if @services_by_specialty == [] && @services_by_health_goal == [] && @services_by_language == []
        @filtered_services = @services_by_service_type.uniq.compact.sort_by(&:id)
      elsif @services_by_specialty == [] && @services_by_health_goal == [] && @services_by_service_type == []
        @filtered_services = @services_by_language.uniq.compact.sort_by(&:id)
      elsif @services_by_specialty == [] && @services_by_language == [] && @services_by_service_type == []
        @filtered_services = @services_by_health_goal.uniq.compact.sort_by(&:id)
      elsif @services_by_health_goal == [] && @services_by_language == [] && @services_by_service_type == []
        @filtered_services = @services_by_specialty.uniq.compact.sort_by(&:id)
      elsif @services_by_specialty == [] && @services_by_service_type == []
        @filtered_services = (@services_by_health_goal & @services_by_language).uniq.compact.sort_by(&:id)
      elsif @services_by_health_goal == [] && @services_by_service_type == []
        @filtered_services = (@services_by_specialty & @services_by_language).uniq.compact.sort_by(&:id)
      elsif @services_by_specialty == [] && @services_by_language == []
        @filtered_services = (@services_by_health_goal & @services_by_service_type).uniq.compact.sort_by(&:id)
      elsif @services_by_health_goal == [] && @services_by_language == []
        @filtered_services = (@services_by_specialty & @services_by_service_type).uniq.compact.sort_by(&:id)
      elsif @services_by_specialty == [] && @services_by_health_goal == []
        @filtered_services = (@services_by_language & @services_by_service_type).uniq.compact.sort_by(&:id)
      elsif @services_by_specialty == []
        @filtered_services = (@services_by_health_goal & @services_by_language & @services_by_service_type).uniq.compact.sort_by(&:id)
      elsif @services_by_health_goal == []
        @filtered_services = (@services_by_specialty & @services_by_language & @services_by_service_type).uniq.compact.sort_by(&:id)
      end
      @filtered_services = @filtered_services.sort_by(&:price)
      @grouped_services = @filtered_services.group_by { |service| service.practitioner }
    end
  end

  def show
    @session = Session.new
  end

  def create
    @service = Service.new(service_params)
    authorize @service
    @practitioner_specialty = PractitionerSpecialty.find_by(practitioner: current_user.practitioner, specialty: Specialty.find(params[:service][:specialty]))
    @service.practitioner = current_user.practitioner
    @service.practitioner_specialty = @practitioner_specialty
    if @service.save!
      favorite_users = @service.practitioner.favorite_users
      favorite_users.each do |user|
        Notification.create(recipient: user, actor: current_user, action: "created new service", notifiable: @service)
      end
      redirect_to practitioner_services_path(current_user.practitioner)
    else
      render :new
    end
  end

  def update
    if @service.price.to_f == service_params[:price].to_f
      if @service.update(service_params)
        redirect_to practitioner_services_path(current_user.practitioner)
      end
    else
      if @service.update(service_params)
        favorite_users = @service.favorite_users
        favorite_users.each do |user|
          Notification.create(recipient: user, actor: current_user, action: "updated the price of service", notifiable: @service)
        end
        redirect_to practitioner_services_path(current_user.practitioner)
      end
    end
  end

  def destroy
    @service.destroy
    redirect_to practitioner_services_path(current_user.practitioner)
  end

  private

  def set_service
    @service = Service.find(params[:id])
    authorize @service
  end

  def set_notifications
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
  end

  def service_params
    params.require(:service).permit(:name, :description, :service_type, :price, :duration)
  end
end
