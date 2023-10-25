class Weather
    def self.current(city)
      url = "http://api.weatherstack.com/current?access_key=#{key}&query=#{ERB::Util.url_encode(city)}"
      response = HTTParty.get url
      OpenStruct.new response.parsed_response['current']
    end
  
    def self.key
      return nil if Rails.env.test?
      raise "WEATHER_APIKEY env variable not defined" if ENV['WEATHER_APIKEY'].nil?
  
      ENV.fetch('WEATHER_APIKEY')
    end
  end