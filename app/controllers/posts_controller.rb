class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_post, only: %i[show edit update destroy]
  before_action :set_notifications, only: %i[index show]

  def index
    if params[:s] && params[:s] != ''
      if user_signed_in? && current_user.admin?
        @posts_by_post = policy_scope(Post).where("(title ILIKE :search) or (short_title ILIKE :search) or (body ILIKE :search)", search: "%#{params[:s]}%")
        @posts_by_sub_category = policy_scope(Post).left_outer_joins(:post_sub_category).where("name ILIKE ?", "%#{params[:s]}%")
        @posts_by_category = policy_scope(Post).left_outer_joins(post_sub_category: :post_category).where("post_categories.name ILIKE ?", "%#{params[:s]}%")
        @posts_by_author = policy_scope(Post).left_outer_joins(:post_author).where("(first_name ILIKE :search) or (last_name ILIKE :search) or (first_name || ' ' || last_name ILIKE :search)", search: "%#{params[:s]}%")
        @posts = (@posts_by_post + @posts_by_category + @posts_by_author).uniq.sort_by(&:created_at).reverse
      else
        @posts_by_post = policy_scope(Post).where("(title ILIKE :search) or (short_title ILIKE :search) or (body ILIKE :search)", search: "%#{params[:s]}%").where(published: true)
        @posts_by_sub_category = policy_scope(Post).left_outer_joins(:post_sub_category).where("name ILIKE ?", "%#{params[:s]}%").where(published: true)
        @posts_by_category = policy_scope(Post).left_outer_joins(post_sub_category: :post_category).where("post_categories.name ILIKE ?", "%#{params[:s]}%").where(published: true)
        @posts_by_author = policy_scope(Post).left_outer_joins(:post_author).where("(first_name ILIKE :search) or (last_name ILIKE :search) or (first_name || ' ' || last_name ILIKE :search)", search: "%#{params[:s]}%").where(published: true)
        @posts = (@posts_by_post + @posts_by_category + @posts_by_author).uniq.sort_by(&:created_at).reverse
      end
    else
      if user_signed_in? && current_user.admin?
        @posts = policy_scope(Post).order(created_at: :desc)
      else
        @posts = policy_scope(Post).where(published: true).order(created_at: :desc)
      end
    end
  end

  def new
    @post = Post.new
    authorize @post
  end

  def create
    @post = Post.new(post_params)
    authorize @post
    @post.post_sub_category = PostSubCategory.find(params[:post][:post_sub_category_id])
    @post.short_title = params[:post][:short_title].parameterize
    @post.save!
    redirect_to posts_path
  end

  def show
  end

  def edit
  end

  def update
    if params[:commit] == 'Publish'
      @post.update(published: true)
      flash[:notice] = 'Post has been published!'
      redirect_to posts_path
    elsif params[:commit] == 'Unpublish'
      @post.update(published: false)
      flash[:notice] = 'Post has been unpublished!'
      redirect_to posts_path
    else
      if @post.update(post_params)
        @post.update(short_title: params[:post][:short_title].parameterize) if params[:post][:short_title]
        @post.update(post_sub_category: PostSubCategory.find(params[:post][:post_sub_category_id])) if params[:post][:post_sub_category_id]
        flash[:notice] = 'Post has been successfully updated!'
      else
        flash[:alert] = 'Something went wrong!'
      end
      redirect_to post_path(@post)
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  private

  def set_post
    @post = Post.find_by_short_title!(params[:id])
    authorize @post
  end

  def set_notifications
    @notifications = Notification.includes(:actor).where(recipient: current_user).order("created_at DESC").unread
  end

  def post_params
    params.require(:post).permit(:title, :body, :short_title, :published, :minutes, :post_author_id, :post_sub_category_id, :photo)
  end
end
