require 'rails_helper'

RSpec.describe '他ユーザーの投稿に対する認可制御', type: :system do
  let(:login_user) { create(:user) }
  let(:other_user) { create(:user) }
  # ここで spec/factories/posts.rb の定義が使われます
  let!(:other_user_post) { create(:post, user: other_user) }

  before do
    sign_in login_user
  end

  describe '他ユーザーの投稿詳細画面' do
    it '編集ボタンおよび削除ボタンが表示されないこと' do
      visit post_path(other_user_post)

      expect(page).not_to have_link '編集'
      expect(page).not_to have_link '削除'
      expect(page).not_to have_button '削除'
    end
  end

  describe '他ユーザーの投稿編集ページへのURL直接アクセス' do
    it 'アクセスが拒否され、編集画面が表示されないこと' do
      visit edit_post_path(other_user_post)

      expect(current_path).not_to eq edit_post_path(other_user_post)
    end
  end
end
