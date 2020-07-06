class PractitionerLanguagesController < ApplicationController
  before_action :set_practitioner_language, only: [:destroy]

  def create
    @practitioner_language = PractitionerLanguage.new
    authorize @practitioner_language
    @practitioner_language.practitioner = Practitioner.find(params[:practitioner_id])
    @practitioner_language.language = Practitioner.find(params[:language_id])
    @practitioner_language.practitioner.save!
    redirect_to root_path
  end

  def destroy
    @practitioner_language.destroy
    redirect_to root_path
  end

  private

  def set_practitioner_language
    @language = Language.find(params[:id])
    authorize @practitioner_language
  end
end
