# frozen_string_literal: true

module Ads
  class UpdateService
    prepend BasicService

    param :ad
    param :data

    def call
      @ad.update_fields(@data, %i[lat lon])
    end
  end
end
