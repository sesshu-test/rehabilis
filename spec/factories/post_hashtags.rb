FactoryBot.define do
  factory :post_hashtag do
    post_id { FactoryBot.create(:post).id }
    hashtag_id { FactoryBot.create(:hashtag).id }
  end
end
