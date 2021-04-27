FactoryBot.define do
  factory :like do
    association :post
    user_id { post.user_id }
  end
end
