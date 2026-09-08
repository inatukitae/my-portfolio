require 'rails_helper'

RSpec.describe "Reflections", type: :request do
  let(:user) { create(:user) }
  let(:post_record) { create(:post, user: user) }

  describe "GET /reflections" do
    let!(:reflection) { create(:reflection, post: post_record, hidden: false) }

    context "ログインしている場合" do
      before { sign_in user }

      it "正常にレスポンスが返ること" do
        get reflections_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get reflections_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /posts/:post_id/reflection" do
    context "ログインしている場合（所有者のポスト）" do
      before { sign_in user }

      it "有効な属性値の場合、Reflectionが作成されること" do
        post_record.reflection&.destroy

        expect {
          post post_reflection_path(post_record), params: {
            reflection: attributes_for(:reflection)
          }
        }.to change(Reflection, :count).by(1)
        expect(response).to redirect_to(post_path(post_record))
      end
    end
  end

  describe "PATCH /reflections/:id/toggle_hidden" do
    let!(:reflection) { create(:reflection, post: post_record, hidden: false) }

    context "自身のReflectionの場合" do
      before { sign_in user }

      it "hiddenのステータスが反転すること" do
        patch toggle_hidden_reflection_path(reflection)
        expect(reflection.reload.hidden).to be true
      end
    end
  end
end
