require 'rails_helper'

RSpec.describe PostHashtag, type: :model do
  subject(:post_hashtag) { build(:post_hashtag) }

  describe "#create" do
    context "保存できる場合" do
      it "すべてのパラメータがあれば保存できる" do
        expect(post_hashtag).to be_valid
        expect(post_hashtag.save).to be_truthy
      end
    end

    context "保存できない場合" do
      it "post_idがなければ保存できない" do
        post_hashtag.post_id = nil
        expect(post_hashtag).to be_invalid
        expect(post_hashtag.save).to be_falsey
      end
      it "hashtag_idがなければ保存できない" do
        post_hashtag.hashtag_id = nil
        expect(post_hashtag).to be_invalid
        expect(post_hashtag.save).to be_falsey
      end
    end

    describe "各モデルとのアソシエーション" do
      let(:association) do
        described_class.reflect_on_association(target)
      end
  
      context "Postモデルとのアソシエーション" do
        let(:target) { :post }
        it "Userとの関連付けはbelongs_toであること" do
          expect(association.macro).to  eq :belongs_to
        end
      end
  
      context "Hashtagモデルとのアソシエーション" do
        let(:target) { :hashtag }
        it "Roomとの関連付けはbelongs_toであること" do
          expect(association.macro).to  eq :belongs_to
        end
      end
    end

  end
end
