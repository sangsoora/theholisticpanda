class PractitionerLanguagesController < ApplicationController
  before_action :set_practitioner_language, only: [:destroy]

  def create
    @practitioner_language = PractitionerLanguage.new
    authorize @practitioner_language
    @practitioner = Practitioner.find(params[:practitioner_id])
    @languages = Language.all.sort_by(&:name)
    @practitioner_language.practitioner = @practitioner
    @practitioner_language.language = Language.find(params[:practitioner][:language_id])
    @practitioner_language.save!
    redirect_to practitioner_profile_path(Practitioner.find(params[:practitioner_id]))
  end

  def destroy
    @practitioner_language.destroy
    @language = @practitioner_language.language
    redirect_to practitioner_profile_path(@practitioner_language.practitioner)
  end

  private

  def set_practitioner_language
    @practitioner_language = PractitionerLanguage.find(params[:id])
    authorize @practitioner_language
  end
end
