# frozen_string_literal: true

require 'securerandom'

module AuthService
  module RpcApi
    def auth(token)
      payload = { token: token }.to_json
      publish(payload, type: 'authenticate')
    end
  end
end
