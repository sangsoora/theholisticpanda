class PractitionerMembershipPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    user.practitioner
  end

  def destroy?
    user_is_practitioner?
  end

  private

  def user_is_practitioner?
    record.practitioner.user == user
  end
end
