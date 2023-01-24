class ChatroomPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show?
    # only the user that created the chatroom or the recipient can access the chatroom
    record.user == user || record.recipient_id == user.id
  end

  def new?
    true
  end

  def create?
    true
  end
end
