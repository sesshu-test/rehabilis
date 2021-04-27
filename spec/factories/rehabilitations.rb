FactoryBot.define do
  factory :rehabilitation do
    association :post
    name { "スクワット" }
    time { nil }
    count { 30 }
  end
end
