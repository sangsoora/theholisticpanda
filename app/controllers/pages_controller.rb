class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @practitioners = Practitioner.all
  end
end
