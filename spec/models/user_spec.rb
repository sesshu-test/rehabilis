require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#create" do
    subject(:user) { FactoryBot.build(:user) }

    context "保存できる場合" do
      it "name、email、password、confirmed_atがある場合、保存できる" do
        expect(user).to be_valid
        expect(user.save).to be_truthy
      end
      it "passwordが6文字の場合、保存できる" do
        user.password = "a" * 6
        user.password_confirmation = "a" * 6
        expect(user).to be_valid
        expect(user.save).to be_truthy
      end
    end

    context "保存できない場合" do
      it "nameが空白の場合、保存できない" do
        user.name = ""
        expect(user).to be_invalid
        expect(user.save).to be_falsey
      end
      it "emailがない場合、保存できない" do
        user.email = ""
        expect(user).to be_invalid
        expect(user.save).to be_falsey
      end
      it "emailが重複している場合、保存できない" do
        FactoryBot.create(:user, email: "test@example.com")
        user.email = "test@example.com"
        expect(user).to be_invalid
        expect(user.save).to be_falsey
      end
            it "passwordがない場合、保存できない" do
        user.password = ""
        expect(user).to be_invalid
        expect(user.save).to be_falsey
      end
      it "passwordが5文字以下の場合、保存できない" do
        user.password = "a" * 5
        user.password_confirmation = "a" * 5
        expect(user).to be_invalid
        expect(user.save).to be_falsey
      end
    end
  end

end
