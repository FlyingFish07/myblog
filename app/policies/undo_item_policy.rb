class UndoItemPolicy
  attr_reader :user, :undo_item

  def initialize(user, model)
    @user = user
    @undo_item = model
  end

  def index?
    true
  end

  def undo?
    user.admin? or undo_item.user_id == user.id
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user_id: user.id)
      end
    end
  end

end
