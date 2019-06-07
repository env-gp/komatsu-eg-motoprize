FactoryBot.define do
  factory :maker do
    name { "ホンダ" }
    order { "1" }
  end

  trait :without_maker_name do
    name { nil }
  end

  trait :without_maker_order do
    order { nil }
  end
end
