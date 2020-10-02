class NewslettersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  before_action :set_newsletter, only: %i[unsubscribe destroy]

  def create
    @newsletter = Newsletter.new(newsletter_params)
    authorize @newsletter
    if @newsletter.save!
      if User.exists?(['email LIKE ?', @newsletter.email])
        @user = User.find_by(email: @newsletter.email)
        @practitioner = Practitioner.find_by(user: @user)
        @user.update(newsletter: true)
      end
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
  end

  def unsubscribe
  end

  def destroy
    if User.exists?(['email LIKE ?', @newsletter.email])
      @user = User.find_by(email: @newsletter.email)
      @practitioner = Practitioner.find_by(user: @user)
      @user.update(newsletter: false)
    end
    @newsletter.destroy
    if params[:commit] == 'Unsubscribe to our newsletter'
      redirect_to root_path
    else
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js
      end
    end
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
