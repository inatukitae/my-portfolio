require 'rails_helper'

RSpec.describe PostPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:post_record) { create(:post, user: user) }

  describe "#update?" do
    it "投稿の所有者であればtrueを返すこと" do
      policy = PostPolicy.new(user, post_record)
      expect(policy.update?).to be true
    end

    it "投稿の所有者でなければfalseを返すこと" do
      policy = PostPolicy.new(other_user, post_record)
      expect(policy.update?).to be false
    end
  end

  describe "#destroy?" do
    it "投稿の所有者であればtrueを返すこと" do
      policy = PostPolicy.new(user, post_record)
      expect(policy.destroy?).to be true
    end

    it "投稿の所有者でなければfalseを返すこと" do
      policy = PostPolicy.new(other_user, post_record)
      expect(policy.destroy?).to be false
    end
  end
end
