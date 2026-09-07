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
end