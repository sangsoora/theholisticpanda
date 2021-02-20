class PractitionersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show filter]
  before_action :set_practitioner, only: %i[show update destroy]
  before_action :set_notifications, only: %i[index show new profile service booking]

  def index
    @practitioners = policy_scope(Practitioner)
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
    @practitioners = Practitioner.checked_practitioners.left_outer_joins(:user).where("(first_name ILIKE :search) or (last_name ILIKE :search) or (first_name || ' ' || last_name ILIKE :search)", search: "%#{params[:query]}%")
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

  def booking
    @practitioner = current_user.practitioner
    authorize @practitioner
    @confirmed_sessions = @practitioner.sessions.includes(:review, service: [practitioner: [{ user: :photo_attachment }]]).where(['status= ?', 'confirmed'])
    @pending_sessions = @practitioner.sessions.includes(:review, service: [practitioner: [{ user: :photo_attachment }]]).where(['paid = ? AND status= ?', true, 'pending'])
    @cancelled_sessions = @practitioner.sessions.includes(:review, service: [practitioner: [{ user: :photo_attachment }]]).where(['status= ?', 'cancelled'])
  end

  def update
    if params[:commit] == 'Proceed To Payment'
      if (params[:practitioner][:agreement_consent][1]) && (params[:practitioner][:background_check_consent][1]) && @practitioner.update(background_check_consent: true, agreement_consent: true, amount_cents: 3500)
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
        redirect_to practitioner_profile_path
      end
    else
      if @practitioner.update(practitioner_params)
        if @practitioner.video && !@practitioner.video.start_with?('http://', 'https://')
          @practitioner.update(video: 'http://' + @practitioner.video)
        end
        @param = practitioner_params
        respond_to do |format|
          format.html { redirect_to practitioner_profile_path }
          format.js
        end
      end
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

  def set_notifications
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
  end

  def practitioner_params
    params.require(:practitioner).permit(:title, :location, :address, :bio, :approach, :video, :latitude, :longitude, :experience, :timezone, :country_code, :checkout_session_id, :amount, :payment_status, :agreement_consent, :agreement_status, :status, :background_check_status, :background_check_consent, :background_check_id, :insurance, :banner_image, :specialty_ids, :language_ids)
  end
end
