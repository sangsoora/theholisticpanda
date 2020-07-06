class LanguagesController < ApplicationController
  before_action :set_language, only: [:destroy]

  def create
    @language = Language.new(language_params)
    authorize @language
    if @language.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    @language.destroy
    redirect_to root_path
  end

  private

  def set_language
    @language = Language.find(params[:id])
    authorize @language
  end

  def language_params
    params.require(:language).permit(:language)
  end
end
