require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "#create" do
    subject(:post) { create(:post) }
    subject(:comment) { build(:comment, post_id: post.id, user_id: post.user.id) }

    context "保存できる場合" do
      it "content、post_id、 user_idがある場合、保存できる" do
        expect(comment).to be_valid
        expect(comment.save).to be_truthy
      end
    end

    context "保存できない場合" do
      it "contentがない場合、保存できない" do
        comment.content = ""
        expect(comment).to be_invalid
        expect(comment.save).to be_falsey
      end
      it "post_idがない場合、保存できない" do
        comment.post_id = nil
        expect(comment).to be_invalid
        expect(comment.save).to be_falsey
      end
      it "user_idがない場合、保存できない" do
        comment.user_id = nil
        expect(comment).to be_invalid
        expect(comment.save).to be_falsey
      end
    end
  end

  describe "各モデルとのアソシエーション" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "Userモデルとのアソシエーション" do
      let(:target) { :user }
      it "Userとの関連付けはbelongs_toであること" do
        expect(association.macro).to  eq :belongs_to
      end
    end

    context "Postモデルとのアソシエーション" do
      let(:target) { :post }
      it "Postとの関連付けはbelongs_toであること" do
        expect(association.macro).to  eq :belongs_to
      end
    end

    context "Notificationモデルとのアソシエーション" do
      let(:target) { :notifications }
      it "Notificationとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :has_many
      end
      it "Commentが削除されたらNotificationも削除されること" do
        comment = create(:comment)
        notification = create(:notification, visitor_id: comment.user.id, visited_id: comment.post.user_id, post_id: comment.post.id, comment_id: comment.id, action: "comment")
        expect { comment.destroy }.to change(Notification, :count).by(-1)
      end
    end

  end
end
