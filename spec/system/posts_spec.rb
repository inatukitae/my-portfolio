require 'rails_helper'

RSpec.describe '投稿機能', type: :system do
  let(:user) { create(:user) }
  let!(:post) { create(:post, user: user, event: '既存の出来事', emotion: '既存の感情', issue: '既存の課題') }

  before do
    sign_in user
  end

  describe '一覧表示' do
    it '投稿一覧が表示されること' do
      visit posts_path
      expect(page).to have_content '既存の出来事'
    end
  end

  describe '新規作成' do
    it '正しい入力で新規投稿ができること' do
      visit new_post_path

      fill_in 'post[event]', with: '新しい出来事'
      fill_in 'post[emotion]', with: '新しい感情'
      fill_in 'post[issue]', with: '新しい課題'
      click_button '整理完了して投稿する'

      expect(page).to have_content '新しい出来事'
    end

    it '出来事が空の場合は新規登録ができないこと' do
      visit new_post_path

      fill_in 'post[event]', with: ''
      click_button '整理完了して投稿する'

      expect(page).to have_content '件のエラーが発生しました'
    end
  end

  describe '詳細表示' do
    it '投稿の詳細が表示されること' do
      visit post_path(post)
      expect(page).to have_content '既存の出来事'
      expect(page).to have_content '既存の感情'
      expect(page).to have_content '既存の課題'
    end
  end

  describe '編集・更新' do
    it '投稿を更新できること' do
      visit edit_post_path(post)

      fill_in 'post[event]', with: '更新された出来事'
      click_button '更新する'

      expect(page).to have_content '更新された出来事'
    end
  end

  describe '削除' do
    it '投稿を削除できること' do
      visit posts_path
      # button_to の場合は click_button, link_to の場合は click_link
      click_on '削除'

      expect(page).not_to have_content '既存の出来事'
    end
  end
end
