require 'rails_helper'

RSpec.describe Ill, type: :model do
  subject(:user) { create(:user) }
  subject(:ill) { build(:ill, user_id: user.id) }

  context "保存できる場合" do
    it "user_id、nameがあれば、保存できる" do
      expect(ill).to be_valid
      expect(ill.save).to be_truthy
    end
    it "nameがnilでも、保存できる" do
      ill.name = nil
      expect(ill).to be_valid
      expect(ill.save).to be_truthy
    end
    it "nameが25文字以下であれば、保存できる" do
      ill.name = "あ" * 25
      expect(ill).to be_valid
      expect(ill.save).to be_truthy
    end
    it "Userは3つまでならIllを、保存できる" do
      ill1 = create(:ill, user_id: user.id)
      ill2 = create(:ill, user_id: user.id)
      expect(ill).to be_valid
      expect(ill.save).to be_truthy
    end
  end

  context "保存できない場合" do
    it "nameが26文字以上であれば、保存できない" do
      ill.name = "あ" * 26
      expect(ill).to be_invalid
      expect(ill.save).to be_falsey
    end
    it "Userは4つ以上のIllを、保存できない" do
      ill1 = create(:ill, user_id: user.id)
      ill2 = create(:ill, user_id: user.id)
      ill3 = create(:ill, user_id: user.id)
      expect(ill).to be_invalid
      expect(ill.save).to be_falsey
    end
  end

  describe "各モデルとのアソシエーション" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "Postモデルとのアソシエーション" do
      let(:target) { :user }
      it "Userとの関連付けはbelongs_toであること" do
        expect(association.macro).to  eq :belongs_to
      end
    end
  end
  
end
