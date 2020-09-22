class NewslettersController < ApplicationController
  before_action :set_newsletter, only: [:destroy]

  def create
    @newsletter = Newsletter.new(newsletter_params)
    authorize @newsletter
    @newsletter.subscribed = true
    @newsletter.save!
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
