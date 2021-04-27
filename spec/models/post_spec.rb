require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "バリデーション" do
    subject(:user) { FactoryBot.create(:user) }
    subject(:post) { FactoryBot.build(:post, user_id: user.id) }

    it "impression, userがある場合、有効である" do
      expect(post).to be_valid
      expect(post.save).to be_truthy
    end

    context "user_id" do
      it "ない場合、無効" do
        post.user_id = nil
        expect(post).to be_invalid
        expect(post.save).to be_falsey
      end
    end

    context "impression" do
      it "ない場合、無効" do
        post.impression = nil
        expect(post).to be_invalid
        expect(post.save).to be_falsey
      end
    end

  end
end
