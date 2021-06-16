class PostCategoriesController < ApplicationController
  before_action :set_post_category, only: [:destroy]

  private

  def set_post_category
    @post_category = PostCategory.find(params[:id])
    authorize @post_category
  end
end
