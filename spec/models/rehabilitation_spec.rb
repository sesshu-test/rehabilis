require 'rails_helper'

RSpec.describe Rehabilitation, type: :model do
  describe "バリデーション" do
    subject(:post) { FactoryBot.create(:post) }
    subject(:rehabilitation) { FactoryBot.create(:rehabilitation, post_id: post.id) }

    it "post_id、name、countがあれば、有効" do
      expect(rehabilitation).to be_valid
      expect(rehabilitation.save).to be_truthy
    end

    it "post_id、name、timeがあれば、有効" do
      rehabilitation.count = nil
      rehabilitation.time = "30"
      expect(rehabilitation).to be_valid
      expect(rehabilitation.save).to be_truthy
    end

    it "post_idがなければ、無効" do
      rehabilitation.post_id = nil
      expect(rehabilitation).to be_invalid
      expect(rehabilitation.save).to be_falsey
    end

    context "name" do
      it "なければ、無効" do
        rehabilitation.name = nil
        expect(rehabilitation).to be_invalid
        expect(rehabilitation.save).to be_falsey
      end
      it "36文字以上なら、無効" do
        rehabilitation.name = "ア" * 36
        expect(rehabilitation).to be_invalid
        expect(rehabilitation.save).to be_falsey
      end
      it "35文字以下なら、有効" do
        rehabilitation.name = "ア" * 35
        expect(rehabilitation).to be_valid
        expect(rehabilitation.save).to be_truthy
      end
    end

    context "count、time" do
      it "両方あれば、無効" do
        rehabilitation.count = "30"
        rehabilitation.time = "30"
        expect(rehabilitation).to be_invalid
        expect(rehabilitation.save).to be_falsey
      end
      it "両方ともなければ、無効" do
        rehabilitation.count = nil
        rehabilitation.time = nil
        expect(rehabilitation).to be_invalid
        expect(rehabilitation.save).to be_falsey
      end
    end

  end
end
