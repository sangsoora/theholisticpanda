class PractitionersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :filter]
  before_action :set_practitioner, only: [:show, :update, :destroy]
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
    @conversation = Conversation.new
  end

  def new
    @practitioner = Practitioner.new
    authorize @practitioner
    @practitioner.user = User.find(params[:user_id])
  end

  def create
    @practitioner = Practitioner.new(practitioner_params)
    authorize @practitioner
    @practitioner.user = User.find(params[:user_id])
    languages = params[:practitioner][:language_ids].reject(&:blank?)
    specialties = params[:practitioner][:specialty_ids].reject(&:blank?)
    if @practitioner.save
      languages.each { |language| PractitionerLanguage.create!(practitioner: @practitioner, language: Language.find(language)) }
      specialties.each { |specialty| PractitionerSpecialty.create!(practitioner: @practitioner, specialty: Specialty.find(specialty)) }
      (0..6).each { |day| WorkingHour.create!(day: day, practitioner: @practitioner, opens: '', closes: '') }
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
      # redirect_to root_path, notice: 'Your application has been received'
    else
      render :new
    end
  end

  def filter
    @practitioners = Practitioner.checked_practitioners.left_outer_joins(:user).where("(first_name ILIKE :search) or (last_name ILIKE :search) or (first_name || ' ' || last_name ILIKE :search)", :search => "%#{params[:query]}%")
    authorize @practitioners
    respond_to :js
  end

  def profile
    @practitioner = current_user.practitioner
    authorize @practitioner
    @columns = %w[title specialties languages certifications memberships country experience bio approach video address healthgoals timezone city name phone]
    @workingdays = %w[Mon Tue Wed Thu Fri Sat Sun]
    @specialties = Specialty.all.sort_by(&:name)
    @languages = Language.all.sort_by(&:name)
    @health_goals = HealthGoal.all.sort_by(&:name)
    @practitioner_specialty = PractitionerSpecialty.new
    @practitioner_language = PractitionerLanguage.new
    @practitioner_social_link = PractitionerSocialLink.new
    @practitioner_certification = PractitionerCertification.new
    @practitioner_membership = PractitionerMembership.new
    @health_goal = UserHealthGoal.new
    @newsletter = Newsletter.find_by(email: @practitioner.user.email) if @practitioner.user.newsletter
    @user = @practitioner.user
    @working_hours = @practitioner.working_hours
  end

  def service
    @practitioner = current_user.practitioner
    authorize @practitioner
    @services = @practitioner.services.includes(:sessions, :specialty, :practitioner)
    @active_serivces = @practitioner.services.where(active: true).includes(:sessions, :specialty, :practitioner)
    @deactivated_serivces = @practitioner.services.where(active: false).includes(:sessions, :specialty, :practitioner)
    @service = Service.new
  end

  def update
    if params[:commit] == 'Proceed To Payment'
      if @practitioner.update(agreement_consent: true, amount_cents: 3500)
        payment_session = Stripe::Checkout::Session.create(
          billing_address_collection: 'required',
          payment_method_types: ['card'],
          line_items: [{
            name: 'Practitioner Onboarding Fee',
            amount: 3500,
            currency: 'cad',
            quantity: 1
          }],
          success_url: practitioner_profile_url,
          cancel_url: practitioner_profile_url
        )
        @practitioner.update(checkout_session_id: payment_session.id)
        redirect_to new_practitioner_practitioner_payment_path(@practitioner)
      else
        render :new
      end
    elsif params[:commit] == 'Proceed to background check'
      @practitioner.update(background_check_status: 'pending', background_check_consent: true)
      PractitionerMailer.with(practitioner: @practitioner).welcome.deliver_now
      redirect_to practitioner_profile_path, notice: 'Thank you for your application'
    else
      if @practitioner.update(practitioner_params)
        if @practitioner.video && !@practitioner.video.start_with?('http://', 'https://')
          @practitioner.update(video: 'http://' + @practitioner.video)
        end
        @param = practitioner_params
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
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
  end

  def practitioner_params
    params.require(:practitioner).permit(:title, :location, :address, :bio, :approach, :video, :latitude, :longitude, :experience, :timezone, :country_code, :checkout_session_id, :amount, :payment_status, :agreement_consent, :agreement_status, :status, :background_check_status, :background_check_consent, :background_check_id, :insurance, :banner_image, :specialty_ids, :language_ids)
  end
end
