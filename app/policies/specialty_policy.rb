class SpecialtyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def create?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def filter?
    true
  end
end
