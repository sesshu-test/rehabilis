require 'rails_helper'

RSpec.describe Like, type: :model do
  describe "バリデーション" do
    subject(:post) { FactoryBot.create(:post) }
    subject(:like) { FactoryBot.build(:like, user_id: post.user_id, post_id: post.id) }

    it "post_idとuser_idがあれば、有効" do
      expect(like).to be_valid
      expect(like.save).to be_truthy
    end

    it "user_idがなければ、無効" do
      like.user_id = nil
      expect(like).to be_invalid
      expect(like.save).to be_falsey
    end

    it "post_idがなければ、無効" do
      like.post_id = nil
      expect(like).to be_invalid
      expect(like.save).to be_falsey
    end

    it "user_idとpost_idが一意でなければ、無効" do
      like.save
      like2 = FactoryBot.build(:like, user_id: like.user_id, post_id: like.post_id)
      expect(like2).to be_invalid
      expect(like2.save).to be_falsey
    end

  end
end
