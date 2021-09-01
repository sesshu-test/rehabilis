FactoryBot.define do
  factory :ill do
    association :user
    name { "前十字靭帯断裂" }
  end
end
