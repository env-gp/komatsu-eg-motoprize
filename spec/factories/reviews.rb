FactoryBot.define do
  factory :review do
    title { Faker::Base.regexify("[aあ]{#{ Review::TITLE_MAX_LENGTH }") }
    body { Faker::Base.regexify("[aあ]{#{ Review::BODY_MAX_LENGTH }}") }
    touring { true }
    race { true }
    shopping { false }
    commute { true }
    work { false }
    etcetera { true }
    association :vehicle
    association :user
    likes_count { 0 }
    status { 1 }
  end

  factory :review_2, parent: :review do
    title { Faker::Base.regexify("[aあ]{#{ Review::TITLE_MAX_LENGTH }") }
    body { Faker::Base.regexify("[aあ]{#{ Review::BODY_MAX_LENGTH }}") }
    touring { false }
    race { false }
    shopping { false }
    commute { false }
    work { false }
    etcetera { true }
    association :vehicle
    association :user
    likes_count { 0 }
    status { 1 }
  end

  factory :review_3, parent: :review do
    title { Faker::Base.regexify("[aあ]{#{ Review::TITLE_MAX_LENGTH }") }
    body { Faker::Base.regexify("[aあ]{#{ Review::BODY_MAX_LENGTH }}") }
    touring { false }
    race { false }
    shopping { false }
    commute { false }
    work { false }
    etcetera { false }
    association :vehicle, factory: :vehicle_second
    association :user
    likes_count { 0 }
    status { 1 }
  end

  factory :review_4, parent: :review do
    title { Faker::Base.regexify("[aあ]{#{ Review::TITLE_MAX_LENGTH }") }
    body { Faker::Base.regexify("[aあ]{#{ Review::BODY_MAX_LENGTH }}") }
    touring { true }
    race { true }
    shopping { false }
    commute { true }
    work { false }
    etcetera { true }
    association :vehicle
    association :user
    likes_count { 0 }
    status { 1 }
    after(:build) do |review|
      review.image.attach(io: File.open(Rails.root.join('spec', 'factories', 'images', 'test.jpg')), filename: 'test.jpg', content_type: 'image/jpg')
    end
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
