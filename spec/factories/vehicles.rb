FactoryBot.define do
  factory :vehicle do
    name { "Rebel500" }
    association :maker
    movie { "oGX8SgeqAw0,YJPNygGGG1I" }

    
    factory :vehicle_second, parent: :vehicle do
      name { "CB400SF" }
      movie { "" }
    end
  end

  trait :without_vehicle_name do
    name { nil }
  end

end
