FactoryBot.define do
  factory :comment do
    association :user
    association :post
    content { "MyString" }
  end
end
