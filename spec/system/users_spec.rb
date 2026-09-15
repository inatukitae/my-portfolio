require 'rails_helper'

RSpec.describe 'ユーザー認証', type: :system do
  let(:user) { create(:user) }

  describe 'ユーザー新規登録' do
    context 'フォームの入力値が正常な場合' do
      it '新規登録が成功すること' do
        visit new_user_registration_path
        fill_in 'ユーザー名', with: '新規ユーザー'
        fill_in 'メールアドレス', with: 'new_user@example.com'
        fill_in 'パスワード', with: 'password123'
        fill_in 'パスワード（確認用）', with: 'password123'
        click_button 'アカウント作成'

        expect(page).to have_content 'ようこそ、新規ユーザー さん'
        expect(page).to have_content 'ログアウト'
      end
    end

    context 'メールアドレスが未入力の場合' do
      it '新規登録に失敗し、エラーメッセージが表示されること' do
        visit new_user_registration_path
        fill_in 'ユーザー名', with: '新規ユーザー'
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: 'password123'
        fill_in 'パスワード（確認用）', with: 'password123'
        click_button 'アカウント作成'

        expect(page).to have_content 'Email を入力してください。'
      end
    end
  end

  describe 'ログイン' do
    context '正しいメールアドレスとパスワードを入力した場合' do
      it 'ログインに成功すること' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'

        expect(page).to have_content "ようこそ、#{user.name} さん"
        expect(page).to have_content 'ログアウト'
      end
    end

    context '誤ったパスワードを入力した場合' do
      it 'ログインに失敗すること' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'wrong_password'
        click_button 'ログイン'

        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe 'ログアウト' do
    it 'ログアウトが成功すること' do
      sign_in user
      visit root_path

      click_on 'ログアウト'

      expect(page).to have_content 'ログイン'
      expect(page).not_to have_content 'ログアウト'
    end
  end
end
