class ReflectionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(:post).where(posts: { user_id: user.id })
    end
  end

  def index?
    true
  end

  def show?
    record.post.user == user
  end

  def new?
    create?
  end

  def create?
    record.post.user == user
  end

  def edit?
    update?
  end

  def update?
    record.post.user == user
  end

  def toggle_hidden?
    record.post.user == user
  end
end