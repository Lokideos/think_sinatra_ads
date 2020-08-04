# frozen_string_literal: true

channel = RabbitMq.consumer_channel
exchange = channel.default_exchange
queue = channel.queue('ads', durable: true)

queue.subscribe do |_delivery_info, properties, payload|
  payload = JSON(payload)
  Thread.current[:request_id] = properties.headers['request_id']
  lat, lon = payload['coordinates']
  Ads::UpdateService.call(payload['id'], lat: lat, lon: lon)

  Application.logger.info(
    'update_ads_coordinates',
    ad: payload['id'],
    coordinates: payload['coordinates']
  )

  exchange.publish(
    '',
    routing_key: properties.reply_to,
    correlation_id: properties.correlation_id
  )
end
