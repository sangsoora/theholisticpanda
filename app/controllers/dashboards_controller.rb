class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def dashboard
    authorize :dashboards, :dashboard?
  end
end
