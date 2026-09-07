class PostPolicy < ApplicationPolicy
  # 例: 編集・更新・削除は「投稿のオーナー（user_idが一致）」のみ許可する
  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end
end