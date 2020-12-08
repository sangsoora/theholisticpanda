class SpecialtyCategoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_specialty_category, only: %i[show destroy]

  def show
  end

  def create
    @specialty_category = SpecialtyCategory.new(specialty_category_params)
    authorize @specialty_category
    if @specialty_category.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    @specialty_category.destroy
    redirect_to root_path
  end

  private

  def set_specialty_category
    @specialty_category = SpecialtyCategory.find(params[:id])
    authorize @specialty_category
  end

  def specialty_category_params
    params.require(:specialty_category).permit(:name)
  end
end
