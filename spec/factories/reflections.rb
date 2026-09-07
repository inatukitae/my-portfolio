FactoryBot.define do
  factory :reflection do
    association :post 
    solution { "MyText" }
    prevention { "MyText" }
  end
end