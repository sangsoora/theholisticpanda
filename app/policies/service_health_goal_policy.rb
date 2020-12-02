class ServiceHealthGoalPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.practitioner
  end

  def destroy?
    user_is_owner?
  end

  private

  def user_is_owner?
    record.practitioner.user == user
  end
end
