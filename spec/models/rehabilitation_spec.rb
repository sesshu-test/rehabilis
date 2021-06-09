require 'rails_helper'

RSpec.describe Rehabilitation, type: :model do
  describe "#create" do
    subject(:post) { FactoryBot.create(:post) }
    subject(:rehabilitation) { FactoryBot.create(:rehabilitation, post_id: post.id) }

    context "保存できる場合" do
      it "post_id、name、countがあれば、保存できる" do
        expect(rehabilitation).to be_valid
        expect(rehabilitation.save).to be_truthy
      end
      it "post_id、name、timeがあれば、保存できる" do
        rehabilitation.count = nil
        rehabilitation.time = "30"
        expect(rehabilitation).to be_valid
        expect(rehabilitation.save).to be_truthy
      end
      it "nameが35文字以下なら、保存できる" do
        rehabilitation.name = "ア" * 35
        expect(rehabilitation).to be_valid
        expect(rehabilitation.save).to be_truthy
      end
    end

    context "保存できない場合" do
      it "post_idがなければ、保存できない" do
        rehabilitation.post_id = nil
        expect(rehabilitation).to be_invalid
        expect(rehabilitation.save).to be_falsey
      end
      it "nameがなければ、保存できない" do
        rehabilitation.name = nil
        expect(rehabilitation).to be_invalid
        expect(rehabilitation.save).to be_falsey
      end
      it "nameが36文字以上なら、保存できない" do
        rehabilitation.name = "ア" * 36
        expect(rehabilitation).to be_invalid
        expect(rehabilitation.save).to be_falsey
      end
      it "count、timeの両方ともあれば、保存できない" do
        rehabilitation.count = "30"
        rehabilitation.time = "30"
        expect(rehabilitation).to be_invalid
        expect(rehabilitation.save).to be_falsey
      end
      it "count、timeの両方ともなければ、保存できない" do
        rehabilitation.count = nil
        rehabilitation.time = nil
        expect(rehabilitation).to be_invalid
        expect(rehabilitation.save).to be_falsey
      end
    end
  end

  describe "各モデルとのアソシエーション" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "Postモデルとのアソシエーション" do
      let(:target) { :post }
      it "Postとの関連付けはbelongs_toであること" do
        expect(association.macro).to  eq :belongs_to
      end
    end
  end
  
end
