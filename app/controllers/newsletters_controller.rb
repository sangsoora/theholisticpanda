class NewslettersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  before_action :set_newsletter, only: [:destroy]

  def create
    @newsletter = Newsletter.new(newsletter_params)
    authorize @newsletter
    @newsletter.subscribed = true
    if @newsletter.save!
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
  end

  def destroy
    @newsletter.destroy
  end

  private

  def set_newsletter
    @newsletter = Newsletter.find(params[:id])
    authorize @newsletter
  end

  def newsletter_params
    params.require(:newsletter).permit(:email)
  end
end
