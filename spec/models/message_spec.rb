require 'rails_helper'

RSpec.describe Message, type: :model do
  subject(:message) { build(:message) }

  describe "#create" do
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

    context "Roomモデルとのアソシエーション" do
      let(:target) { :room }
      it "Roomとの関連付けはbelongs_toであること" do
        expect(association.macro).to  eq :belongs_to
      end
    end

    context "Notificationモデルとのアソシエーション" do
      let(:target) { :notifications }
      it "Notificationとの関連付けはhas_manyであること" do
        expect(association.macro).to eq :has_many
      end
      it "Messageが削除されたらNotificationも削除されること" do
        message = create(:message)
        notification = create(:notification, visitor_id: message.user.id, visited_id: 1, message_id: message.id, action: "message")
        expect { message.destroy }.to change(Notification, :count).by(-1)
      end
    end
    
  end

end
