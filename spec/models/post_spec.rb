require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "#create" do
    subject(:user) { create(:user) }
    subject(:post) { build(:post, user_id: user.id) }

    context "保存できる場合" do
      it "impression, userがある場合、保存できる" do
        expect(post).to be_valid
        expect(post.save).to be_truthy
      end
    end

    context "保存できない場合" do
      it "user_idがない場合、保存できない" do
        post.user_id = nil
        expect(post).to be_invalid
        expect(post.save).to be_falsey
      end
      it "impressionがない場合、保存できない" do
        post.impression = nil
        expect(post).to be_invalid
        expect(post.save).to be_falsey
      end
    end
  end

  describe "各モデルとのアソシエーション" do
    let(:association) do
      described_class.reflect_on_association(target)
    end
    let(:post) { create(:post) }

    context "Likeモデルとのアソシエーション" do
      let(:target) { :likes }
      it "Likeとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :has_many
      end
      it "Postが削除されたらLikeも削除されること" do
        like = create(:like, post_id: post.id)
        expect { post.destroy }.to change(Like, :count).by(-1)
      end
    end

    context "Commentモデルとのアソシエーション" do
      let(:target) { :comments }
      it "Commentとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :has_many
      end
      it "Postが削除されたらCommentも削除されること" do
        comment = create(:comment, post_id: post.id)
        expect { post.destroy }.to change(Comment, :count).by(-1)
      end
    end

    context "Rehabilitationモデルとのアソシエーション" do
      let(:target) { :rehabilitations }
      it "Commentとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :has_many
      end
      it "Postが削除されたらRehabilitationも削除されること" do
        rehabilitation = create(:rehabilitation, post_id: post.id)
        expect { post.destroy }.to change(Rehabilitation, :count).by(-1)
      end
    end

    context "Notificationモデルとのアソシエーション" do
      let(:target) { :notifications }
      it "Notificationとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :has_many
      end
      it "Postが削除されたらNotificationも削除されること" do
        notification = create(:notification, post_id: post.id, visitor_id: 1, visited_id: 1, action: "like")
        expect { post.destroy }.to change(Notification, :count).by(-1)
      end
    end

    context "Post_hashtagモデルとのアソシエーション" do
      let(:target) { :post_hashtags }
      it "Post_hashtagとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :has_many
      end
      it "Postが削除されたらPost_hashtagも削除されること" do
        post_hashtag = create(:post_hashtag, post_id: post.id)
        expect { post.destroy }.to change(PostHashtag, :count).by(-1)
      end
    end

  end
end
