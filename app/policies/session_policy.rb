class SessionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    user_is_practitioner? || user_is_customer?
  end

  def create?
    true
  end

  def update?
    user_is_practitioner? || user_is_customer?
  end

  def destroy?
    user_is_practitioner? || user_is_customer?
  end

  private

  def user_is_practitioner?
    record.service.practitioner_specialty.practitioner.user == user
  end

  def user_is_customer?
    record.user == user
  end
end