FactoryBot.define do
  factory :reflection do
    association :post
    solution { "テストの解決策" }
    prevention { "テストの再発防止策" }
    hidden { false }

    # 非公開（hidden: true）の状態を簡単に呼び出せるtrait
    trait :hidden do
      hidden { true }
    end

    # バリデーションエラーや異常系をテストするための無効な状態
    trait :invalid do
      solution { "" }
      prevention { "" }
    end
  end
end
