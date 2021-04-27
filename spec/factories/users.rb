FactoryBot.define do
  factory :user do
    name { "sample" }
    email { |n| "example-#{n}@gmail.com" }
    password {"foobar"}
    confirmed_at { Time.now }
  end
end
