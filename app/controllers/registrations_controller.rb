class RegistrationsController < Devise::RegistrationsController
  def create
    super
  end

  def edit
  end

  protected

  def update_resource(resource, params)
    # Require current password if user is trying to change password.
    return super if params["password"]&.present?

    # Allows user to update registration information without password.
    resource.update_without_password(params.except("current_password"))
  end

  def after_update_path_for(resource)
    if resource.practitioner
      practitioner_profile_path(resource.practitioner)
    else
      user_path(resource)
    end
  end
end
