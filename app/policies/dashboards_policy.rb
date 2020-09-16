class DashboardsPolicy < Struct.new(:user, :dashboards)
  def dashboard?
    user.admin
  end
end
