FactoryBot.define do
  factory :tokyo, class: :prefecture do
    name { "東京都" }
    geonames_id { 1850147 }
  end

  factory :kochi, class: :prefecture do
    name { "高知県" }
    geonames_id { 1859133 }
  end

  factory :hiroshima, class: :prefecture do
    name { "東京都" }
    geonames_id { 1862413 }
  end
end
