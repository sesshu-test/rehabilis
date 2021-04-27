require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "バリデーション " do
    subject(:post) { FactoryBot.create(:post) }
    subject(:comment) { FactoryBot.create(:comment) }

    it "コメントが行われた場合に保存できる" do
      notification = FactoryBot.build(:notification, post_id: comment.post.id, comment_id: comment.id, action: "comment")
      expect(notification).to be_valid
    end
  end
end
