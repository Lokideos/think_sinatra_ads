# frozen_string_literal: true

require_relative 'rpc_api'

module AuthService
  class RpcClient
    extend Dry::Initializer[undefined: false]
    include RpcApi

    option :queue, default: proc { create_queue }
    option :reply_queue, default: proc { create_reply_queue }
    option :lock, default: proc { Mutex.new }
    option :condition, default: proc { ConditionVariable.new }

    def self.fetch
      Thread.current['auth_service.rpc_client'] ||= new.start
    end

    def start
      @reply_queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
        if properties[:correlation_id] == @correlation_id
          @user_id = JSON(payload)['user_id']
          @delivery_tag = delivery_info.delivery_tag
          @lock.synchronize { @condition.signal }
        end
      end

      self
    end

    private

    attr_writer :correlation_id

    def create_queue
      channel = RabbitMq.channel
      channel.queue('auth', durable: true)
    end

    def create_reply_queue
      channel = RabbitMq.channel
      channel.queue('auth-ads-reply', durable: true)
    end

    def publish(payload, opts = {})
      self.correlation_id = SecureRandom.uuid

      @lock.synchronize do
        @queue.publish(
          payload,
          opts.merge(app_id: 'ads',
                     correlation_id: @correlation_id,
                     reply_to: @reply_queue.name)
        )

        @condition.wait(@lock)
        @reply_queue.channel.ack(@delivery_tag)

        @user_id
      end
    end
  end
end
