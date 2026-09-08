require 'rails_helper'

RSpec.describe Reflection, type: :model do
  describe 'バリデーション' do
    it '有効な属性値である場合、有効であること' do
      reflection = FactoryBot.build(:reflection)
      expect(reflection).to be_valid
    end

    it 'solutionが空の場合、無効であること' do
      reflection = FactoryBot.build(:reflection, solution: nil)
      expect(reflection).not_to be_valid
      expect(reflection.errors[:solution]).to be_present
    end

    it 'postが紐づいていない場合、無効であること' do
      reflection = FactoryBot.build(:reflection, post: nil)
      expect(reflection).not_to be_valid
      expect(reflection.errors[:post]).to be_present
    end
  end
end