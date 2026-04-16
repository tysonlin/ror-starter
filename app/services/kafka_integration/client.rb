# frozen_string_literal: true

module KafkaIntegration
  class Client
    def self.instance
      @instance ||= ::Kafka.new(seed_brokers: seed_brokers)
    end

    def self.seed_brokers
      ENV.fetch("KAFKA_BROKERS", "localhost:9092").split(",")
    end

    def self.topic
      ENV.fetch("KAFKA_TOPIC", "entity-events")
    end
  end
end
