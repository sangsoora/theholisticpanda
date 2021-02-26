class RegistrationsController < Devise::RegistrationsController
  before_action :find_bot, only: :create

  def create
    super
    if session[:previous_url] == '/become-a-practitioner'
      @user.update(signup_path: session[:previous_url])
    end
  end

  def edit
  end

  def update
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
    @user = User.find(resource.id)

    @update = update_resource(@user, account_update_params)
    @param = account_update_params
    if resource.practitioner
      @practitioner = resource.practitioner
    end
    unless account_update_params[:password]
      respond_to do |format|
        if resource.practitioner
          format.html { redirect_to practitioner_profile_path }
        else
          format.html { redirect_to user_path(resource) }
        end
        format.js
      end
    else
      if @update
        # Sign in the user bypassing validation in case their password changed
        sign_in @user, :bypass => true
      end
      if resource.practitioner
        redirect_to practitioner_profile_path(@practitioner)
      else
        redirect_to user_path(resource)
      end
    end
  end

  protected

  def find_bot
    return unless params[:hp] == 1
    head :ok
  end

  def update_resource(resource, params)
    # Require current password if user is trying to change password.
    return super if params["password"]&.present?

    # Allows user to update registration information without password.
    resource.update_without_password(params.except("current_password"))
  end
end
