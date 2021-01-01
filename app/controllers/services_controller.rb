class ServicesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_notifications, only: %i[index show]
  before_action :set_service, only: %i[show update destroy]

  def index
    @services = policy_scope(Service).includes(:specialty, :practitioner_specialty, :languages, practitioner: [{user: :photo_attachment}]).group_by { |service| service.specialty }
    @services = @services.sort_by { |k, _v| k[:name] }.to_h
    if params[:search] && params[:search][:health_goal]
      @primary_filtered_services = Service.filter_by_health_goal(params[:search][:health_goal].reject(&:blank?))
      @filtered_services_specialties = @primary_filtered_services.uniq.compact.map { |service| service.specialty }.uniq
      @filtered_services_languages = @primary_filtered_services.uniq.compact.map { |service| service.languages }.flatten.uniq
      if params[:filter]
        if params[:filter][:specialty].length >= 2
          if params[:filter][:language].length >= 2
            if params[:filter][:service_type] != ""
              @filtered_with_specialty = @primary_filtered_services.filter_by_specialty(params[:filter][:specialty].reject(&:blank?))
              @filtered_with_language = @primary_filtered_services.filter_by_language(params[:filter][:language].reject(&:blank?))
              @filtered_with_type = @primary_filtered_services.filter_by_service_type(params[:filter][:service_type])
              @filtered_services = (@filtered_with_specialty & @filtered_with_language & @filtered_with_type)
            else
              @filtered_with_specialty = @primary_filtered_services.filter_by_specialty(params[:filter][:specialty].reject(&:blank?))
              @filtered_with_language = @primary_filtered_services.filter_by_language(params[:filter][:language].reject(&:blank?))
              @filtered_services = (@filtered_with_specialty & @filtered_with_language)
            end
          elsif params[:filter][:service_type] != ""
            @filtered_with_specialty = @primary_filtered_services.filter_by_specialty(params[:filter][:specialty].reject(&:blank?))
            @filtered_with_type = @primary_filtered_services.filter_by_service_type(params[:filter][:service_type])
            @filtered_services = (@filtered_with_specialty & @filtered_with_type)
          else
            @filtered_services = @primary_filtered_services.filter_by_specialty(params[:filter][:specialty].reject(&:blank?))
          end
        elsif params[:filter][:language].length >= 2
          if params[:filter][:service_type] != ""
            @filtered_with_language = @primary_filtered_services.filter_by_language(params[:filter][:language].reject(&:blank?))
            @filtered_with_type = @primary_filtered_services.filter_by_service_type(params[:filter][:service_type])
            @filtered_services = (@filtered_with_language & @filtered_with_type)
          else
            @filtered_services = @primary_filtered_services.filter_by_language(params[:filter][:language].reject(&:blank?))
          end
        elsif params[:filter][:service_type] != ""
          @filtered_services = @primary_filtered_services.filter_by_service_type(params[:filter][:service_type])
        elsif params[:filter][:specialty].length == 1 && params[:filter][:language].length == 1 && params[:filter][:service_type] == ""
          @filtered_services = @primary_filtered_services
        end
        @filtered_services = @filtered_services.uniq.compact.sort_by(&:price)
      else
        @filtered_services = @primary_filtered_services.uniq.compact.sort_by(&:price)
      end
    end
  end

  def show
    @session = Session.new
    @times = ['00:00', '00:30', '01:00', '01:30', '02:00', '02:30', '03:00', '03:30', '04:00', '04:30', '05:00', '05:30', '06:00', '06:30', '07:00', '07:30', '08:00', '08:30', '09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30', '17:00', '17:30', '18:00', '18:30', '19:00', '19:30', '20:00', '20:30', '21:00', '21:30', '22:00', '22:30', '23:00', '23:30']
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
        Notification.create(recipient: user, actor: current_user, action: 'created new service', notifiable: @service)
      end
      redirect_to practitioner_services_path(current_user.practitioner)
    else
      render :new
    end
  end

  def update
    if @service.price.to_f == service_params[:price].to_f
      redirect_to practitioner_services_path(current_user.practitioner) if @service.update(service_params)
    else
      if @service.update(service_params)
        favorite_users = @service.favorite_users
        favorite_users.each do |user|
          Notification.create(recipient: user, actor: current_user, action: 'updated the price of service', notifiable: @service)
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
    @notifications = Notification.includes(:actor).where(recipient: current_user).order('created_at DESC').unread
  end

  def service_params
    params.require(:service).permit(:name, :description, :service_type, :price, :duration)
  end
end
