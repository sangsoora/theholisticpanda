class NotificationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(recipient: user).unread
    end
  end

  def update?
    user_is_recipient?
  end

  def destroy?
    user_is_recipient?
  end

  private

  def user_is_recipient?
    record.recipient == user
  end
end
