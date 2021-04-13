class ConfirmationsController < Devise::ConfirmationsController

  private

  def after_confirmation_path_for(resource_name, resource)
    if resource.signup_path == '/become-a-practitioner'
      become_a_practitioner_path
    elsif resource.signup_path.start_with?('/services/')
      service_path(Service.find(resource.signup_path.split('/').last.to_i))
    else
      root_path
    end
  end
end
