require 'rails_helper'

RSpec.describe Relationship, type: :model do
  subject(:relationship) { FactoryBot.build(:relationship) }

  it "follower_id、followed_idがあれば、有効" do
    expect(relationship).to be_valid
    expect(relationship.save).to be_truthy
  end

  it "follower_idがなければ、無効" do
    relationship.follower_id = nil
    expect(relationship).to be_invalid
    expect(relationship.save).to be_falsey
  end

  it "followed_idがなければ、無効" do
    relationship.followed_id = nil
    expect(relationship).to be_invalid
    expect(relationship.save).to be_falsey
  end
end
