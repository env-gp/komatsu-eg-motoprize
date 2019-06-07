FactoryBot.define do
  factory :admin_user, class: :user do
    name  { "山田 太郎" }
    sequence(:email) { |n| "tester#{n}@examle.com" }
    password { "test-password" }
    admin { true }
  end

  factory :user, parent: :admin_user do
    name  { "山田 太郎(一般)" }
    password { "test-password" }
    admin { false }
  end

  trait :without_user_name do
    name { nil }
  end

  trait :without_user_email do
    email { nil }
  end
end
