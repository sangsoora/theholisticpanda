class RegistrationsController < Devise::RegistrationsController
  before_action :find_bot, only: :create
  invisible_captcha only: [:create]

  def create
    super
    if session[:previous_url] == '/become-a-practitioner'
      @user.update(signup_path: session[:previous_url])
    elsif session[:previous_url].start_with?('/services/')
      @user.update(signup_path: session[:previous_url])
    end
  end

  def edit
  end

  def update
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
    @user = User.find(resource.id)
    @param = account_update_params
    @practitioner = resource.practitioner if resource.practitioner
    if params[:commit] == 'Upload' && params[:user][:photo]
      @user.photo.purge if @user.photo.attached?
      if update_resource(@user, account_update_params)
        crop_setting = { x: params[:crop_x], y: params[:crop_y], w: params[:crop_w], h: params[:crop_h] }
        @user.update(crop_setting: crop_setting)
        flash[:notice] = 'Your profile photo has been uploaded.'
        redirect_to practitioner_profile_path
      end
    elsif params[:commit] == 'Delete Profile Photo'
      @user.photo.purge
      @user.update(crop_setting: nil)
      flash[:notice] = 'Your profile photo has been deleted.'
      redirect_to practitioner_profile_path
    elsif params[:commit] == 'Save Card for Payment' || params[:commit] == 'Add New Card'
      # Create customer on Stripe if doesn't exist already
      unless @user.stripe_id
        customer = Stripe::Customer.create({
          email: @user.email,
          name: @user.full_name,
          phone: @user.phone_number
        })
        @user.update(stripe_id: customer.id)
      end
      # Send back to user profile page if adding new card from user profile page
      if session[:previous_url].start_with?('/users/')
        setup_session = Stripe::Checkout::Session.create(
          payment_method_types: ['card'],
          mode: 'setup',
          customer: @user.stripe_id,
          billing_address_collection: 'required',
          success_url: user_url(resource),
          cancel_url: user_url(resource)
        )
        @user.update(setup_session_id: setup_session.id)
        redirect_to user_payment_path
      # Send back to session payment page if adding new card from session payment page
      elsif session[:previous_url].start_with?('/sessions/')
        setup_session = Stripe::Checkout::Session.create(
          payment_method_types: ['card'],
          mode: 'setup',
          customer: @user.stripe_id,
          billing_address_collection: 'required',
          success_url: new_session_payment_url(Session.find(session[:previous_url].split('/')[2].to_i)),
          cancel_url: new_session_payment_url(Session.find(session[:previous_url].split('/')[2].to_i))
        )
        @user.update(setup_session_id: setup_session.id)
        redirect_to user_payment_path
      end
    elsif account_update_params[:password]
      if update_resource(@user, account_update_params)
        # Sign in the user bypassing validation in case their password changed
        sign_in @user, :bypass => true
      end
      if resource.practitioner
        redirect_to practitioner_profile_path
      else
        redirect_to user_path(resource)
      end
    else
      if update_resource(@user, account_update_params)
        respond_to do |format|
          if resource.practitioner
            format.html { redirect_to practitioner_profile_path }
          else
            format.html { redirect_to user_path(resource) }
          end
          format.js
        end
      else
        respond_to do |format|
          if resource.practitioner
            format.html { render 'practitioners/profile' }
          else
            format.html { render 'users/show' }
          end
          format.js
        end
      end
    end
  end

  protected

  def find_bot
    redirect_to root_path if params[:hp] == '1'
  end

  def update_resource(resource, params)
    # Require current password if user is trying to change password.
    return super if params['password']&.present?

    # Allows user to update registration information without password.
    resource.update_without_password(params.except('current_password'))
  end
end
