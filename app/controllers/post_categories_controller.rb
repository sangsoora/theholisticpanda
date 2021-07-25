class PostCategoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_post_category, only: %i[show destroy]
  before_action :set_notifications, only: [:show]

  def show
    if user_signed_in? && current_user.admin?
      @posts = @post_category.posts.order(created_at: :desc)
    else
      @posts = @post_category.posts.where(published: true).order(created_at: :desc)
    end
  end

  private

  def set_post_category
    @post_category = PostCategory.find_by_name!(params[:id].gsub('_', ' '))
    authorize @post_category
  end

  def set_notifications
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
  end
end
