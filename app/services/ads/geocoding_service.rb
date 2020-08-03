# frozen_string_literal: true

module Ads
  class GeocodingService
    prepend BasicService

    param :ad

    attr_reader :ad

    def call
      coordinates = GeocodeService::Client.new.geocode(ad: @ad.values) || [nil, nil]

      @ad.update(lat: coordinates[0], lon: coordinates[1])
    end
  end
end
