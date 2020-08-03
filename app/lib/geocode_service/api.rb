# frozen_string_literal: true

module GeocodeService
  module Api
    def geocode(ad)
      response = connection.post('geocode') do |request|
        request.headers['Content-Type'] = 'application/json'
        request.body = ad
      end

      response.body['coordinates'] if response.success?
    end
  end
end
