class PractitionerLanguagesController < ApplicationController
  before_action :set_practitioner_language, only: [:destroy]

  def create
    @practitioner_language = PractitionerLanguage.new
    authorize @practitioner_language
    @practitioner = Practitioner.find(params[:practitioner_id])
    @languages = Language.all.sort_by(&:name)
    @practitioner_language.practitioner = @practitioner
    @practitioner_language.language = Language.find(params[:practitioner][:language_id])
    if @practitioner_language.save!
      respond_to do |format|
        format.html { redirect_to practitioner_profile_path(@practitioner) }
        format.js
      end
    end
  end

  def destroy
    @practitioner = @practitioner_language.practitioner
    @practitioner_language.destroy
    @language = @practitioner_language.language
    @languages = Language.all.sort_by(&:name)
    respond_to do |format|
      format.html { redirect_to practitioner_profile_path(@practitioner_language.practitioner) }
      format.js
    end
  end

  private

  def set_practitioner_language
    @practitioner_language = PractitionerLanguage.find(params[:id])
    authorize @practitioner_language
  end
end
