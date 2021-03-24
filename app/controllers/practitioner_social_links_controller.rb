class PractitionerSocialLinksController < ApplicationController
  # before_action :set_practitioner_social_link, only: [:destroy]

  # def create
  #   @practitioner_social_link = PractitionerSocialLink.new(practitioner_social_link_params)
  #   authorize @practitioner_social_link
  #   @practitioner = Practitioner.find(params[:practitioner_id].split('_').last.to_i)
  #   @practitioner_social_link.practitioner = @practitioner
  #   if !@practitioner_social_link.url.include?('http://' || 'https://')
  #     @practitioner_social_link.url = 'http://' + @practitioner_social_link.url
  #   end
  #   if @practitioner_social_link.save!
  #     respond_to do |format|
  #       format.html { redirect_to practitioner_profile_path }
  #       format.js
  #     end
  #   end
  # end

  # def destroy
  #   @practitioner = @practitioner_social_link.practitioner
  #   @practitioner_social_link.destroy
  #   respond_to do |format|
  #     format.html { redirect_to practitioner_profile_path }
  #     format.js
  #   end
  # end

  # private

  # def set_practitioner_social_link
  #   @practitioner_social_link = PractitionerSocialLink.find(params[:id])
  #   authorize @practitioner_social_link
  # end

  # def practitioner_social_link_params
  #   params.require(:practitioner_social_link).permit(:media_type, :url)
  # end
end
