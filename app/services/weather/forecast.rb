module Weather
  class Forecast
    
    attr_accessor :prefecture, :data, :weather_id, :main, :description
    
    OPENWEATHERMAP_URL = 'https://api.openweathermap.org/data/2.5/weather'

    CONDITIONS = [
      'clear_sky',
      'scattered_cloud',
      'cloud',
      'light_rain',
      'rain',
      'thunderstorm_rain',
      'thunderstorm',
      'snow',
      'drizzle',
    ]
    
    USE_API_TIME_SEC = 600

    def initialize(prefecture_id)
      @prefecture = Prefecture.find(prefecture_id)
      @data =
      {
        'id': @prefecture.geonames_id,
        'units': 'metric',
        'appid': ENV['OPEN_WEATHER_API_KEY'],
      }
    end

    def weather_condition
      forecast = WeatherForecast.find_by(prefecture_id: @prefecture.id)

      if forecast.present?
        diff = Time.zone.now - forecast.acquired_at
        if diff.to_i >= USE_API_TIME_SEC
          forecast = weather_forecast_update(api_request())
        end
      else
        forecast = weather_forecast_update(api_request())
      end

      @weather_id = forecast.weather_id
      @main = forecast.main
      @description = forecast.description

      CONDITIONS.each_with_index do |condition, index|
        break condition if send("#{condition}?")
        break nil if CONDITIONS.length == index + 1
      end
    end

    private

    def api_request
      query=@data.to_query
      uri = URI("#{OPENWEATHERMAP_URL}?" + query)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      response = Net::HTTP.get_response(uri)
      JSON.parse(response.body, symbolize_names: true)
    end

    def weather_forecast_update(res_data)
      weather = res_data[:weather][0]

      obj = {
        prefecture_id: @prefecture.id,
        weather_id: weather[:id].to_i,
        main: weather[:main],
        description: weather[:description],
        acquired_at: Time.zone.now,
      }

      WeatherForecast.find_or_initialize_by(prefecture_id: obj[:prefecture_id]).update_attributes(obj)
      WeatherForecast.find_by(prefecture_id: obj[:prefecture_id])
    end

    def clear_sky?
      description == 'clear sky' || description == 'few clouds'
    end

    def scattered_cloud?
      description == 'scattered clouds'
    end

    def cloud?
      description == 'broken clouds' || description == 'overcast clouds'
    end

    def light_rain?
      (500..504).include?(weather_id)
    end

    def rain?
      (511..531).include?(weather_id)
    end

    def thunderstorm_rain?
      /thunderstorm/ === description && /rain/ === description
    end

    def thunderstorm?
      /thunderstorm/ === description && !(/rain/ === description)
    end

    def snow?
      main == 'Snow'
    end

    def drizzle?
      main == 'Drizzle'
    end
  end
end
