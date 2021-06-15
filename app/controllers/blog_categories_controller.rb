class BlogCategoriesController < ApplicationController
  before_action :set_blog_category, only: [:destroy]

  private

  def set_blog_category
    @blog_category = BlogCategory.find(params[:id])
    authorize @blog_category
  end
end
