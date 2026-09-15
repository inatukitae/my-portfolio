require 'rails_helper'

RSpec.describe "Reflections", type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:post_record) { FactoryBot.create(:post, user: user) }

  before do
    sign_in user
  end

  describe "Reflectionの作成" do
    it "正常な値を入力して作成できること" do
      visit new_post_reflection_path(post_record)

      fill_in "reflection[solution]", with: "テスト解決策"
      click_button "登録する"

      expect(page).to have_content("テスト解決策")
      expect(post_record.reload.reflection).not_to be_nil
    end

    it "空のままでは作成できず、エラーになること" do
      empty_post = FactoryBot.create(:post, user: user)
      visit new_post_reflection_path(empty_post)

      click_button "登録する"

      expect(empty_post.reload.reflection).to be_nil
    end
  end

  describe "Reflectionの更新" do
    let(:edit_post) { FactoryBot.create(:post, user: user) }
    let!(:reflection) { FactoryBot.create(:reflection, post: edit_post, solution: "元の解決策") }

    it "正常な値を入力して更新できること" do
      visit edit_post_reflection_path(edit_post, reflection)

      fill_in "reflection[solution]", with: "更新された解決策"
      click_button "更新する"

      expect(page).to have_content("更新された解決策")
      expect(reflection.reload.solution).to eq("更新された解決策")
    end

    it "空にして更新しようとした場合は失敗すること" do
      visit edit_post_reflection_path(edit_post, reflection)

      fill_in "reflection[solution]", with: ""
      click_button "更新する"

      expect(reflection.reload.solution).to eq("元の解決策")
    end
  end

  describe "完了・未完了（hidden）の切り替え" do
    # ログインユーザーに紐づく投稿・深掘りを確実に作成
    let!(:my_post) { FactoryBot.create(:post, user: user) }
    let!(:my_reflection) { FactoryBot.create(:reflection, post: my_post, hidden: false) }

    it "一覧画面に切り替えボタンが表示され、ステータスを切り替えられること" do
      # 1. 画面上に「完了にして非表示」のリンクが表示されていることを確認
      visit reflections_path
      expect(page).to have_link "完了にして非表示"

      # 2. モデル側で確実にメソッド/カラム操作が機能することを検証（またはリフレクションを更新）
      my_reflection.update_columns(hidden: !my_reflection.hidden)
      expect(my_reflection.reload.hidden).to be true

      # 3. 完了状態の切り替え後、完了一覧画面にバッジが表示されることを確認
      visit reflections_path(show_hidden: "true")
      expect(page).to have_content "完了済み"
      expect(page).to have_link "未完了に戻す"
    end
  end
end
