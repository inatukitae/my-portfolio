require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    it '有効な属性の場合は保存できること' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'emailが空の場合は無効であること' do
      user = build(:user, email: nil)
      expect(user).to be_invalid
    end
  end
end
