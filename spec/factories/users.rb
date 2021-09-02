FactoryBot.define do
  factory :user do
    name { "sample" }
    introduction { "よろしくお願いします。" }
    sequence(:email) { |n| "person#{n}@example.com" }
    password {"foobar"}
    confirmed_at { Time.now }
  end
end
