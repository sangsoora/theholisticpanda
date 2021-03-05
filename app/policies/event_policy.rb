class EventPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.admin?
  end

  def show?
    true
  end

  def update?
    user.admin?
  end

  def destory?
    user.admin?
  end
end
