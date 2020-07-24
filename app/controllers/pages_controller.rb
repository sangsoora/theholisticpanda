class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :become_a_practitioner]

  def home
    @practitioners = Practitioner.all
  end

  def become_a_practitioner
  end
end
