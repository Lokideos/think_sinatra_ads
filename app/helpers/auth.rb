# frozen_string_literal: true

module Auth
  class UnknownAuthType < StandardError; end
  class Unauthorized < StandardError; end

  AUTH_TOKEN = /\ABearer (?<token>.+)\z/.freeze

  def user_id(auth_mode: :http)
    case auth_mode
    when :http then http_authentication
    when :rpc then rpc_authentication
    else
      raise UnknownAuthType
    end
  end

  private

  def http_authentication
    user_id = http_auth_service.auth(matched_token)
    raise Unauthorized if user_id.blank?

    user_id
  end

  def rpc_authentication
    user_id = rpc_auth_service.auth(matched_token)
    raise Unauthorized if user_id.blank?

    user_id
  end

  def http_auth_service
    @http_auth_service ||= AuthService::Client.new
  end

  def rpc_auth_service
    @rpc_auth_service ||= AuthService::RpcClient.fetch
  end

  def matched_token
    result = auth_header&.match(AUTH_TOKEN)
    return if result.blank?

    result[:token]
  end

  def auth_header
    request.env['HTTP_AUTHORIZATION']
  end
end
