require 'rails_helper'

RSpec.describe Relationship, type: :model do
  subject(:relationship) { build(:relationship) }

  describe "#create" do
    context "保存できる場合" do
      it "follower_id、followed_idがあれば、保存できる" do
        expect(relationship).to be_valid
        expect(relationship.save).to be_truthy
      end
    end

    context "保存できない場合" do
      it "follower_idがなければ、保存できない" do
        relationship.follower_id = nil
        expect(relationship).to be_invalid
        expect(relationship.save).to be_falsey
      end
      it "followed_idがなければ、保存できない" do
        relationship.followed_id = nil
        expect(relationship).to be_invalid
        expect(relationship.save).to be_falsey
      end
    end

    context "一意性の検証" do
      before do
        @relation = create(:relationship)
        @user1 = build(:relationship)
      end
      it "follower_idとfollowing_idの組み合わせは一意でなければ保存できない" do
        relation2 = build(:relationship, follower_id: @relation.follower_id, followed_id: @relation.followed_id)
        expect(relation2).to be_invalid
        expect(relation2.save).to be_falsey
      end
      it "follower_idが同じでもfollowing_idが違うなら保存できる" do
        relation2 = build(:relationship, follower_id: @relation.follower_id, followed_id: @user1.followed_id)
        expect(relation2).to be_valid
        expect(relation2.save).to be_truthy
      end
      it "follower_idが違うならfollowing_idが同じでも保存できる" do
        relation2 = build(:relationship, follower_id: @user1.follower_id, followed_id: @relation.followed_id)
        expect(relation2).to be_valid
        expect(relation2.save).to be_truthy
      end
    end
  end

  describe "各モデルとのアソシエーション" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "仮想モデルfollowerとのアソシエーション" do
      let(:target) { :follower }
      it "Followerとの関連付けはbelongs_toであること" do
        expect(association.macro).to  eq :belongs_to
      end
    end

    context "仮想モデルfollowedとのアソシエーション" do
      let(:target) { :followed }
      it "Followingとの関連付けはbelongs_toであること" do
        expect(association.macro).to  eq :belongs_to
      end
    end
  end
end
