FactoryBot.define do
  factory :maker do
    name { "ホンダ" }
    order { "1" }
  end

  factory :maker_suzuki, parent: :maker do
    name { "スズキ" }
    order { "1" }
  end

  factory :maker_yamaha, parent: :maker do
    name { "ヤマハ" }
    order { "1" }
  end

  trait :without_maker_name do
    name { nil }
  end

  trait :without_maker_order do
    order { nil }
  end
end
