class PractitionerSocialLinksController < ApplicationController
  before_action :set_practitioner_social_link, only: [:destroy]

  def create
    @practitioner_social_link = PractitionerSocialLink.new(practitioner_social_link_params)
    authorize @practitioner_social_link
    @practitioner = Practitioner.find(params[:practitioner_id].split('_').last.to_i)
    @practitioner_social_link.practitioner = @practitioner
    if @practitioner_social_link.media_type != 'Email' && @practitioner_social_link.media_type != 'Phone' && !@practitioner_social_link.url.start_with?('http://', 'https://')
      @practitioner_social_link.url = 'https://' + @practitioner_social_link.url
    end
    if @practitioner_social_link.save!
      if @practitioner.practitioner_social_links.where(media_type: 'Email').count > 1
        @practitioner.practitioner_social_links.where(media_type: 'Email').first.destroy
      end
      if @practitioner.practitioner_social_links.where(media_type: 'Phone').count > 1
        @practitioner.practitioner_social_links.where(media_type: 'Phone').first.destroy
      end
      respond_to do |format|
        format.html { redirect_to practitioner_profile_path }
        format.js
      end
    end
  end

  def destroy
    @practitioner = @practitioner_social_link.practitioner
    @practitioner_social_link.destroy
    respond_to do |format|
      format.html { redirect_to practitioner_profile_path }
      format.js
    end
  end

  private

  def set_practitioner_social_link
    @practitioner_social_link = PractitionerSocialLink.find(params[:id])
    authorize @practitioner_social_link
  end

  def practitioner_social_link_params
    params.require(:practitioner_social_link).permit(:media_type, :url)
  end
end
