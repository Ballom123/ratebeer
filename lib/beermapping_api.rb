class BeermappingApi
    def self.places_in(city)
      url = "http://beermapping.com/webservice/loccity/#{key}/"
  
      response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
      places = response.parsed_response["bmp_locations"]["location"]
  
      return [] if places.is_a?(Hash) and places['id'].nil?
  
      places = [places] if places.is_a?(Hash)
      places.map do | place |
        Place.new(place)
      end
    end
  
    def self.key
      "3d1a3d8b874499bb9f1cc21ef97de72a"
    end
  end