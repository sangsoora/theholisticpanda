class ConversationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    user_is_sender? || user_is_recipient?
  end

  def create?
    true
  end

  private

  def user_is_sender?
    record.sender == user
  end

  def user_is_recipient?
    record.recipient == user
  end
end
