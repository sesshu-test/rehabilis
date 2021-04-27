FactoryBot.define do
  factory :post do
    association :user
    impression { "頑張りました" }
  end
end
