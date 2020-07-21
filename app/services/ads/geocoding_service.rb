# frozen_string_literal: true

module Ads
  class GeocodingService
    prepend BasicService

    param :initial_ad

    attr_reader :ad

    def call
      coordinates = GeocodeService::Client.new.geocode(ad: @initial_ad) || [nil, nil]
      @ad = Ad.find(id: @initial_ad[:id])
      @ad.update(lat: coordinates[0], lon: coordinates[1])
    end
  end
end
