FactoryBot.define do
  factory :post do
    association :user
    event { "テストの出来事" }
    emotion { "テストの感情" }
    issue { "テストの課題" }
  end
end