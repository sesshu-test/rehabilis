require 'rails_helper'

RSpec.describe Message, type: :model do
  subject(:message) { FactoryBot.build(:message) }

  describe "create" do
    context "保存できる場合" do
      it "全てのパラメーターが揃っていれば保存できる" do
        expect(message).to be_valid
        expect(message.save).to be_truthy
      end
      it "contentが1文字以上なら保存できる" do
        message.content = "A" * 1
        expect(message).to be_valid
        expect(message.save).to be_truthy
      end
      it "contentが1000文字以下なら保存できる" do
        message.content = "A" * 1000
        expect(message).to be_valid
        expect(message.save).to be_truthy
      end
    end

    context "保存できない場合" do
      it "user_idがnilの場合は保存できない" do
        message.user_id = nil
        expect(message).to be_invalid
        expect(message.save).to be_falsey
      end
      it "room_idがnilの場合は保存できない" do
        message.room_id = nil
        expect(message).to be_invalid
        expect(message.save).to be_falsey
      end
      it "messageがnilの場合は保存できない" do
        message.content = nil
        expect(message).to be_invalid
        expect(message.save).to be_falsey
      end
      it "messageが1001文字以上の場合は保存できない" do
        message.content = "A" * 1001
        expect(message).to be_invalid
        expect(message.save).to be_falsey
      end
    end
  end

end
