require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "#create" do
    let(:post) { create(:post) }
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it "いいねが行われた場合、保存できる" do
      like = create(:like)
      notification = build(:notification, visited_id: user1.id, visitor_id: user2.id, post_id: post.id, action: "like")
      expect(notification).to be_valid
      expect(notification.save).to be_truthy
    end

    it "コメントが行われた場合、保存できる" do
      comment = create(:comment)
      notification = build(:notification, visited_id: user1.id, visitor_id: user2.id, post_id: post.id, comment_id: comment.id, action: "comment")
      expect(notification).to be_valid
      expect(notification.save).to be_truthy
    end

    it "ダイレクトメッセージが行われた場合、保存できる" do
      message = create(:message)
      notification = build(:notification, visited_id: user1.id, visitor_id: user2.id, message_id: message.id, action: "message")
      expect(notification).to be_valid
      expect(notification.save).to be_truthy
    end

    it "フォローが行われた場合、保存できる" do
      notification = build(:notification, visited_id: user1.id, visitor_id: user2.id, action: "follow")
      expect(notification).to be_valid
      expect(notification.save).to be_truthy
    end

    it "フォローが行われた場合、aciontがなければ保存できない" do
      notification = build(:notification, visited_id: user1.id, visitor_id: user2.id)
      expect(notification).to be_invalid
      expect(notification.save).to be_falsey
    end
  end

  describe "各モデルとのアソシエーション" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "Postモデルとのアソシエーション" do
      let(:target) { :post }
      it "Tweetとの関連付けはbelongs_toであること" do
        expect(association.macro).to eq :belongs_to
      end
    end

    context "Commentモデルとのアソシエーション" do
      let(:target) { :comment }
      it "Commentとの関連付けはbelongs_toであること" do
        expect(association.macro).to eq :belongs_to
      end
    end

    context "Messageモデルとのアソシエーション" do
      let(:target) { :message }
      it "Messageとの関連付けはbelongs_toであること" do
        expect(association.macro).to eq :belongs_to
      end
    end

    context "visitorとのアソシエーション" do
      let(:target) { :visitor }
      it "Visitorとの関連付けはbelongs_toであること" do
        expect(association.macro).to eq :belongs_to
      end
    end

    context "visitedとのアソシエーション" do
      let(:target) { :visited }
      it "Visitedとの関連付けはbelongs_toであること" do
        expect(association.macro).to eq :belongs_to
      end
    end
  end

end
