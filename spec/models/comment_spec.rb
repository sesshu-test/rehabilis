require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "バリデーション" do
    subject(:post) { FactoryBot.create(:post) }
    subject(:comment) { FactoryBot.build(:comment, post_id: post.id, user_id: post.user.id) }

    it "content、post_id、 user_idがあれば、有効" do
      expect(comment).to be_valid
      expect(comment.save).to be_truthy
    end

    context "content" do
      it "ない場合、無効" do
        comment.content = ""
        expect(comment).to be_invalid
        expect(comment.save).to be_falsey
      end
    end

    context "post_id" do
      it "ない場合、無効" do
        comment.post_id = nil
        expect(comment).to be_invalid
        expect(comment.save).to be_falsey
      end
    end

    context "user_id" do
      it "ない場合、無効" do
        comment.user_id = nil
        expect(comment).to be_invalid
        expect(comment.save).to be_falsey
      end
    end

  end
end
