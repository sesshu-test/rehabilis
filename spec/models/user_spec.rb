require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    subject(:user) { FactoryBot.build(:user) }

    it "name、email、password、confirmed_atがある場合、有効である" do
      expect(user).to be_valid
      expect(user.save).to be_truthy
    end

    context "name" do
      it "空白の場合、無効である" do
        user.name = ""
        expect(user).to be_invalid
        expect(user.save).to be_falsey
      end
    end

    context "email" do
      it "ない場合、無効である" do
        user.email = ""
        expect(user).to be_invalid
        expect(user.save).to be_falsey
      end
      it "重複している場合、無効である" do
        FactoryBot.create(:user, email: "test@example.com")
        user.email = "test@example.com"
        expect(user).to be_invalid
        expect(user.save).to be_falsey
      end
    end

    context "password" do
      user = FactoryBot.build(:user)
      it "ない場合、無効である" do
        user.password = ""
        expect(user).to be_invalid
        expect(user.save).to be_falsey
      end
      it "5文字以下の場合、無効である" do
        user.password = "a" * 5
        user.password_confirmation = "a" * 5
        expect(user).to be_invalid
        expect(user.save).to be_falsey
      end
      it "6文字の場合、有効である" do
        user.password = "a" * 6
        user.password_confirmation = "a" * 6
        expect(user).to be_valid
        expect(user.save).to be_truthy
      end
    end

  end

end
