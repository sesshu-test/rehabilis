FactoryBot.define do
  factory :user do
    name { "sample" }
    sequence(:email) { |n| "person#{n}@example.com" }
    #email { |n| "example-#{n}@gmail.com" }
    password {"foobar"}
    confirmed_at { Time.now }
  end
end
