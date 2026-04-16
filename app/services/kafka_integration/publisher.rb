# frozen_string_literal: true

require "protobuf/entity_event"

module KafkaIntegration
  class Publisher
    def self.publish_entity_created(payload)
      event = Protobuf::EntityEvent.new(name: payload[:name], description: payload[:description])
      producer = KafkaIntegration::Client.instance.producer

      producer.produce(event.to_proto, topic: KafkaIntegration::Client.topic)
      producer.deliver_messages
    ensure
      producer&.shutdown
    end
  end
end
