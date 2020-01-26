class Prefecture < ApplicationRecord
  has_many :users
  has_many :weather_forecasts
end
