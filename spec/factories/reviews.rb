FactoryBot.define do
  factory :review do
    title { Faker::Base.regexify("[aあ]{#{ Review::TITLE_MAX_LENGTH }") }
    body { Faker::Base.regexify("[aあ]{#{ Review::BODY_MAX_LENGTH }}") }
    association :vehicle
    association :user
  end

  factory :review_2, parent: :review do
    title { Faker::Base.regexify("[aあ]{#{ Review::TITLE_MAX_LENGTH }") }
    body { Faker::Base.regexify("[aあ]{#{ Review::BODY_MAX_LENGTH }}") }
    association :vehicle
    association :user
  end

  factory :review_3, parent: :review do
    title { Faker::Base.regexify("[aあ]{#{ Review::TITLE_MAX_LENGTH }") }
    body { Faker::Base.regexify("[aあ]{#{ Review::BODY_MAX_LENGTH }}") }
    association :vehicle, factory: :vehicle_second
    association :user
  end

  trait :without_title do
    title { nil }
  end

  trait :without_body do
    body { nil }
  end

  trait :title_max_over do
    title { Faker::Base.regexify("[aあ]{#{ (Review::TITLE_MAX_LENGTH + 1) }}") }
  end

  trait :body_max_over do
    body { Faker::Base.regexify("[aあ]{#{ (Review::BODY_MAX_LENGTH + 1) }}") }
  end

  trait :title_include_comma do
    title { "A,B" }
  end

  trait :body_include_comma do
    body { "A,B" }
  end
end
