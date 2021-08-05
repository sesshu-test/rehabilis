require 'rails_helper'

RSpec.describe Hashtag, type: :model do
  subject(:hashtag) { build(:hashtag) }

  describe "#create" do
    context "保存できる場合" do
      it "nameがあれば保存できる" do
        expect(hashtag).to be_valid
        expect(hashtag.save).to be_truthy
      end
      it "nameが50文字以下なら保存できる" do
        hashtag.name = "A" * 50
        expect(hashtag).to be_valid
        expect(hashtag.save).to be_truthy
      end
    end

    context "保存できない場合" do
      it "nameがなければ保存できない" do
        hashtag.name = nil
        expect(hashtag).to be_invalid
        expect(hashtag.save).to be_falsey
      end
      it "nameが51文字以上であれば保存できない" do
        hashtag.name = "A" * 51
        expect(hashtag).to be_invalid
        expect(hashtag.save).to be_falsey
      end
    end
  end

  describe "各モデルとのアソシエーション" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "Post_hashtagモデルとのアソシエーション" do
      let(:target) { :post_hashtags }
      it "Post_hashtagとの関連付けはhas_manyであること" do
        expect(association.macro).to  eq :has_many
      end
    end

  end
end
