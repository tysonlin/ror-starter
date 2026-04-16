# frozen_string_literal: true

require "protobuf/entity_event"

module KafkaIntegration
  class Consumer
    def consume
      consumer = KafkaIntegration::Client.instance.consumer(group_id: ENV.fetch("KAFKA_GROUP_ID", "ror-starter-group"))
      consumer.subscribe(KafkaIntegration::Client.topic)

      consumer.each_message do |message|
        process_message(message.value)
      end
    ensure
      consumer&.stop
    end

    # Separated to keep consumer loop simple and testable.
    def process_message(raw_payload)
      event = Protobuf::EntityEvent.decode(raw_payload)
      Entity.create!(name: event.name, description: event.description)
    end
  end
end
