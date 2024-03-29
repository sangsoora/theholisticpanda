class PractitionerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    user_is_practitioner?
  end

  def destroy?
    user_is_practitioner?
  end

  def profile?
    user_is_practitioner?
  end

  def service?
    user_is_practitioner?
  end

  def booking?
    user_is_practitioner?
  end

  def filter?
    true
  end

  def discovery_call?
    true
  end

  private

  def user_is_practitioner?
    record.user == user
  end
end
