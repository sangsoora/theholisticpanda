class ReviewsController < ApplicationController
  before_action :set_review, only: [:destroy]

  def create
    @review = Review.new(review_params)
    authorize @review
    @review.session = Session.find(params[:session_id])
    if @review.save!
      redirect_to user_sessions_path(current_user)
    end
  end

  def destroy
    @review.destroy
    redirect_to root_path
  end

  private

  def set_review
    @review = Review.find(params[:id])
    authorize @review
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
