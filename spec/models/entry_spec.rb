require 'rails_helper'

RSpec.describe Entry, type: :model do
  subject(:entry) { FactoryBot.build(:entry) }

  describe "create" do
    context "保存できる場合" do
      it "全てのパラメーターが揃っていれば保存できる" do
        expect(entry).to be_valid
        expect(entry.save).to be_truthy
      end
    end

    context "保存できない場合" do
      it "user_idがnilの場合は保存できない" do
        entry.user_id = nil
        expect(entry).to be_invalid
        expect(entry.save).to be_falsey
      end
      it "room_idがnilの場合は保存できない" do
        entry.room_id = nil
        expect(entry).to be_invalid
        expect(entry.save).to be_falsey
      end
    end

    context "一意性の検証" do
      it "user_idとroom_idの組み合わせは一意でなければ保存できない" do
        entry2 = FactoryBot.build(:entry, user_id: entry.user_id, room_id: entry.room_id)
        expect(entry).to be_invalid
        expect(entry.save).to be_falsey
      end
    end

  end

end
