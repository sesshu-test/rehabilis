require 'rails_helper'

RSpec.describe Like, type: :model do
  describe "#create" do
    subject(:post) { FactoryBot.create(:post) }
    subject(:like) { FactoryBot.build(:like, user_id: post.user_id, post_id: post.id) }

    context "保存できる場合" do
      it "post_idとuser_idがある場合、保存できる" do
        expect(like).to be_valid
        expect(like.save).to be_truthy
      end
    end

    context "保存できない場合" do
      it "user_idがない場合、保存できない" do
        like.user_id = nil
        expect(like).to be_invalid
        expect(like.save).to be_falsey
      end
      it "post_idがない場合、保存できない" do
        like.post_id = nil
        expect(like).to be_invalid
        expect(like.save).to be_falsey
      end
      it "user_idとpost_idが一意でない場合、保存できない" do
        like.save
        like2 = FactoryBot.build(:like, user_id: like.user_id, post_id: like.post_id)
        expect(like2).to be_invalid
        expect(like2.save).to be_falsey
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
  end
end
