class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    user_is_page_owner?
  end

  def booking?
    user_is_page_owner?
  end

  def favorite?
    user_is_page_owner?
  end

  def notification?
    user_is_page_owner?
  end

  def timezone?
    user_is_page_owner?
  end

  def payment?
    user_is_page_owner?
  end

  private

  def user_is_page_owner?
    record == user
  end
end
