class PractitionersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_practitioner, only: [:show, :profile, :service, :update, :destroy]
  before_action :set_notifications, only: [:index, :show, :new, :profile, :service]

  def index
    @practitioners = policy_scope(Practitioner)
    if params[:search]
      # if params[:search][:eduaction]
      #   if params[:search][:education].count == 2
      #     @practitioners_by_education = Practitioner.filter_by_education(params[:search][:education][1])
      #   elsif params[:search][:education].count > 2
      #     @practitioners_by_education = params[:search][:education].reject(&:blank?).map do |keyword|
      #       Practitioner.filter_by_education(keyword)
      #     end
      #     @practitioners_by_education = @practitioners_by_education.map { |practitioners| practitioners.first }
      #   elsif params[:search][:education].count == 1
      #     @practitioners_by_education = []
      #   end
      # else
      #   @practitioners_by_education = []
      # end
      if params[:search][:specialty]
        if params[:search][:specialty].count == 2
          @practitioners_by_specialty = Practitioner.filter_by_specialty(params[:search][:specialty][0])
        elsif params[:search][:specialty].count > 2
          @practitioners_by_specialty = params[:search][:specialty].tap(&:pop).map do |keyword|
            Practitioner.filter_by_specialty(keyword)
          end
          @practitioners_by_specialty.flatten!
        elsif params[:search][:specialty].count == 1
          @practitioners_by_specialty = []
        end
      else
        @practitioners_by_specialty = []
      end
      if params[:search][:health_goal]
        if params[:search][:health_goal].count == 2
          @practitioners_by_health_goal = Practitioner.filter_by_health_goal(params[:search][:health_goal][0])
        elsif params[:search][:health_goal].count > 2
          @practitioners_by_health_goal = params[:search][:health_goal].tap(&:pop).map do |keyword|
            Practitioner.filter_by_health_goal(keyword)
          end
          @practitioners_by_health_goal.flatten!
        elsif params[:search][:health_goal].count == 1
          @practitioners_by_health_goal = []
        end
      else
        @practitioners_by_health_goal = []
      end
      if params[:search][:language]
        if params[:search][:language].count == 2
          @practitioners_by_language = Practitioner.filter_by_language(params[:search][:language][0])
        elsif params[:search][:language].count > 2
          @practitioners_by_language = params[:search][:language].tap(&:pop).map do |keyword|
            Practitioner.filter_by_language(keyword)
          end
          @practitioners_by_language.flatten!
        elsif params[:search][:language].count == 1
          @practitioners_by_language = []
        end
      else
        @practitioners_by_language = []
      end
      if params[:search][:service_type]
        if params[:search][:service_type].present?
          @practitioners_by_service_type = Practitioner.filter_by_service_type(params[:search][:service_type].split(' ')[0].downcase)
        else
          @practitioners_by_service_type = []
        end
      else
        @practitioners_by_service_type = []
      end
      if @practitioners_by_specialty == [] && @practitioners_by_health_goal == [] && @practitioners_by_language == []
        @filtered_practitioners = @practitioners_by_service_type.uniq.compact.sort_by(&:id)
      elsif @practitioners_by_specialty == [] && @practitioners_by_health_goal == [] && @practitioners_by_service_type == []
        @filtered_practitioners = @practitioners_by_language.uniq.compact.sort_by(&:id)
      elsif @practitioners_by_specialty == [] && @practitioners_by_language == [] && @practitioners_by_service_type == []
        @filtered_practitioners = @practitioners_by_health_goal.uniq.compact.sort_by(&:id)
      elsif @practitioners_by_health_goal == [] && @practitioners_by_language == [] && @practitioners_by_service_type == []
        @filtered_practitioners = @practitioners_by_specialty.uniq.compact.sort_by(&:id)
      elsif @practitioners_by_specialty == [] && @practitioners_by_service_type == []
        @filtered_practitioners = (@practitioners_by_health_goal & @practitioners_by_language).uniq.compact.sort_by(&:id)
      elsif @practitioners_by_health_goal == [] && @practitioners_by_service_type == []
        @filtered_practitioners = (@practitioners_by_specialty & @practitioners_by_language).uniq.compact.sort_by(&:id)
      elsif @practitioners_by_specialty == [] && @practitioners_by_language == []
        @filtered_practitioners = (@practitioners_by_health_goal & @practitioners_by_service_type).uniq.compact.sort_by(&:id)
      elsif @practitioners_by_health_goal == [] && @practitioners_by_language == []
        @filtered_practitioners = (@practitioners_by_specialty & @practitioners_by_service_type).uniq.compact.sort_by(&:id)
      elsif @practitioners_by_specialty == [] && @practitioners_by_health_goal == []
        @filtered_practitioners = (@practitioners_by_language & @practitioners_by_service_type).uniq.compact.sort_by(&:id)
      elsif @practitioners_by_specialty == []
        @filtered_practitioners = (@practitioners_by_health_goal & @practitioners_by_language & @practitioners_by_service_type).uniq.compact.sort_by(&:id)
      elsif @practitioners_by_health_goal == []
        @filtered_practitioners = (@practitioners_by_specialty & @practitioners_by_language & @practitioners_by_service_type).uniq.compact.sort_by(&:id)
      end
    end
  end

  def show
  end

  def new
    @practitioner = Practitioner.new
    @practitioner.user = User.find(params[:user_id])
    authorize @practitioner
  end

  def create
    @practitioner = Practitioner.new(practitioner_params)
    @practitioner.user = User.find(params[:user_id])
    authorize @practitioner
    languages = params[:practitioner][:language_ids].reject(&:blank?)
    specialties = params[:practitioner][:specialty_ids].reject(&:blank?)
    if @practitioner.save
      languages.each { |language| PractitionerLanguage.create!(practitioner: @practitioner, language: Language.find(language)) }
      specialties.each { |specialty| PractitionerSpecialty.create!(practitioner: @practitioner, specialty: Specialty.find(specialty)) }
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
      # redirect_to root_path, notice: 'Your application has been received'
    else
      render :new
    end
  end

  def profile
    @columns = ['specialties', 'languages', 'country', 'experience', 'certification', 'bio', 'workingdays', 'workinghours', 'video', 'website', 'address']
    @workingdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    @specialties = Specialty.all.sort_by(&:name)
    @languages = Language.all.sort_by(&:name)
    @practitioner_specialty = PractitionerSpecialty.new
    @practitioner_language = PractitionerLanguage.new
    @practitioner_social_link = PractitionerSocialLink.new
  end

  def service
    @services = @practitioner.services
    @service = Service.new
  end

  def update
    if params[:commit] == 'Proceed to background check'
      @practitioner.update(background_check_status: 'pending', background_check_consent: true)
      redirect_to root_path, notice: 'Thank you for your application'
    else
      if @practitioner.update(practitioner_params)
        if params[:practitioner][:workingday_ids]
          @workingdays = params[:practitioner][:workingday_ids].reject(&:blank?).join(', ')
          @practitioner.update(working_days: @workingdays)
        end
        respond_to do |format|
          format.html { redirect_to practitioner_profile_path(@practitioner) }
          format.js
        end
      end
    end
    # if @practitioner.update(practitioner_params)
    #   redirect_to practitioner_path(@practitioner)
    # else
    #   render :edit
    # end
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

  def set_notifications
    @notifications = Notification.where(recipient: current_user).order("created_at DESC").unread
  end

  def practitioner_params
    params.require(:practitioner).permit(:location, :address, :bio, :video, :website, :latitude, :longitude, :certification, :experience, :working_days, :starting_hour, :ending_hour, :country_code, :background_check_status, :background_check_consent, :background_check_id, :photo)
  end
end
