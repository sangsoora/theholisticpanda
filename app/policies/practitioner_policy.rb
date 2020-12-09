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
    !user_is_practitioner?
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

  def filter?
    true
  end

  private

  def user_is_practitioner?
    record.user == user
  end
end
