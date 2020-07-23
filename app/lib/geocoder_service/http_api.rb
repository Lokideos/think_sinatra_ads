# frozen_string_literal: true

module GeocoderService
  module HttpApi
    ESSENTIAL_KEYS = %i[id city].freeze

    def geocode_later(ad)
      connection.post('geocode') do |request|
        request.body = prepared_ad(ad).to_json
      end
    end

    private

    def prepared_ad(ad)
      { ad: ad.values.slice(*ESSENTIAL_KEYS) }
    end
  end
end
