class ReflectionPolicy < ApplicationPolicy
  def update?
    record.post.user == user
  end

  def destroy?
    record.post.user == user
  end

  def show?
    record.post.user == user
  end

  def toggle_hidden?
    record.post.user == user
  end
end
