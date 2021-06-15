class BlogsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_blog, only: %i[show update destroy]
  before_action :set_notifications, only: %i[index show]

  def index
    @blogs = policy_scope(Blog)
  end

  def create
    @blog = Blog.new(blog_params)
    @blog.blog_category = BlogCategory.find(params[:blog][:blog_category_id])
    authorize @blog
    @blog.save!
    redirect_to blogs_path
  end

  def show
  end

  def update
    if @blog.update(blog_params)
      flash[:notice] = 'Blog has been successfully updated!'
    else
      flash[:alert] = 'Something went wrong!'
    end
    redirect_to blog_path(@blog)
  end

  def destroy
    @blog.destroy
    redirect_to blogs_path
  end

  private

  def set_blog
    @blog = Blog.find(params[:id])
    authorize @blog
  end

  def set_notifications
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
  end

  def blog_params
    params.require(:blog).permit(:title, :author, :body, :link, :photo)
  end
end
