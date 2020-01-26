# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forecast, type: :services do
  let!(:tokyo) { FactoryBot.create(:tokyo) }
  let!(:kochi) { FactoryBot.create(:kochi) }
  let!(:user) { FactoryBot.create(:admin_user, prefecture: tokyo) }
  let(:response) do
    {
      "weather": [
        {
            "id": 803,
            "main": "Clouds",
            "description": "broken clouds",
            "icon": "04n"
        }
      ]
    }
  end
  
  before do
    WebMock.stub_request(:get, "#{Weather::Forecast::OPENWEATHERMAP_URL}?id=1850147&units=metric&appid=#{ENV['OPEN_WEATHER_API_KEY']}").to_return(
      body: response.to_json
    )
  end
  
  describe 'weather_condition' do
    forecast = Weather::Forecast.new(user.prefecture_id)
    expect(forecast.weather_condition).to eq(Weather::Forecast::CLOUD)
  end
end