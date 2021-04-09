class PaymentMethodPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    user_is_page_owner?
  end

  def destroy?
    user_is_page_owner?
  end

  private

  def user_is_page_owner?
    record.user == user
  end
end
