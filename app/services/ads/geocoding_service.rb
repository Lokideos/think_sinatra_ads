# frozen_string_literal: true

module Ads
  class GeocodingService
    prepend BasicService

    param :ad

    attr_reader :coordinates

    def call
      geocoder_response = GeocodeService::Client.new.geocode(ad: @ad.values)

      @coordinates = if geocoder_response.present?
                       { lat: geocoder_response[0], lon: geocoder_response[1] }
                     else
                       { lat: nil, lon: nil }
                     end
    end
  end
end
