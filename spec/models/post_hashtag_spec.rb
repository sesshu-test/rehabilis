require 'rails_helper'

RSpec.describe PostHashtag, type: :model do
  subject(:post_hashtag) { FactoryBot.build(:post_hashtag) }

  describe "create" do
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

  end
end
